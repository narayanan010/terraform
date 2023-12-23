package main

import (
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
	"go.uber.org/zap"

	"context"
	"encoding/json"
	"os"
	"strconv"
	"time"
)

type SnsHandler struct {
	c           *dynamodb.Client
	TableName   string
	ExpireAfter time.Duration
}

/*
{"notificationType":"Bounce",
	"bounce":{
		"feedbackId":"0100018321f344a6-40afee98-d1ef-4801-a348-89818bddfc11-000000",
		"bounceType":"Permanent",
		"bounceSubType":"General",
		"bouncedRecipients":[
			{"emailAddress":"bounce@simulator.amazonses.com","action":"failed","status":"5.1.1","diagnosticCode":"smtp; 550 5.1.1 user unknown"}
		],
		"timestamp":"2022-09-09T11:12:14.000Z",
		"remoteMtaIp":"52.72.180.157",
		"reportingMTA":"dns; a8-90.smtp-out.amazonses.com"
	},
	"mail":{
		"timestamp":"2022-09-09T11:12:13.973Z",
		"source":"james.nurmi@capterra.com",
		"sourceArn":"arn:aws:ses:us-east-1:350125959894:identity/capterra.com",
		"sourceIp":"213.149.62.61",
		"callerIdentity":"gdm-admin-access",
		"sendingAccountId":"350125959894",
		"messageId":"0100018321f34295-3ffcd89e-4aff-45f4-9cb9-2f40aa2cc61e-000000",
		"destination":["bounce@simulator.amazonses.com"],
		"headersTruncated":false,
		"headers":[
			{"name":"From","value":"james.nurmi@capterra.com"},
			{"name":"To","value":"bounce@simulator.amazonses.com"},
			{"name":"Subject","value":"Bounce trigger plz"},
			{"name":"MIME-Version","value":"1.0"},
			{"name":"Content-Type","value":"multipart/alternative;  boundary=\\"----=_Part_301936_731396976.1662721933976\\""}],
		"commonHeaders":{
			"from":["james.nurmi@capterra.com"],
			"to":["bounce@simulator.amazonses.com"],
			"subject":"Bounce trigger plz"}
	}
	},
*/
type SesNotification struct {
	NotificationType string // Bounce, ...
	Bounce           *BounceNotification
	Mail             MailInformation
}

type BounceNotification struct {
	FeedbackId       string
	BounceType       string
	BounceSubType    string
	BounceRecipients []struct {
		EmailAddress   string
		Action         string
		Status         string
		DiagnosticCode string
	}
	Timestamp    string
	RemoteMtaIp  string
	ReportingMta string
}

type MailInformation struct {
	Timestamp        time.Time
	Source           string
	SourceArn        string
	SourceIp         string
	CallerIdentity   string
	SendingAccountId string
	MessageId        string
	Destination      []string
	HeadersTruncated bool
	Headers          []struct {
		Name  string
		Value string
	}
	CommonHeaders struct {
		From    []string
		To      []string
		Subject string
	}
}

func (h SnsHandler) Handle(ctx context.Context, evt events.SNSEvent) error {
	zap.L().Info("Received SNS event",
		zap.Any("context", ctx),
		zap.Any("event", evt),
	)
	for _, record := range evt.Records {
		notice := SesNotification{}
		err := json.Unmarshal([]byte(record.SNS.Message), &notice)
		if err != nil {
			zap.L().Error("Couldn't parse notification",
				zap.Error(err),
			)
			return err
		}
		M, err := attributevalue.MarshalMap(notice)
		if err != nil {
			zap.L().Error("Couldn't marshal notification",
				zap.Error(err),
			)
			return err
		}
		M["MessageId"] = &types.AttributeValueMemberS{
			Value: notice.Mail.MessageId,
		}
		M["ExpireAfter"] = &types.AttributeValueMemberN{
			Value: strconv.FormatInt(time.Now().Add(h.ExpireAfter).Unix(), 10),
		}
		_, err = h.c.PutItem(ctx, &dynamodb.PutItemInput{
			TableName: aws.String(h.TableName),
			Item:      M,
		})
		if err != nil {
			zap.L().Error("Couldn't put item",
				zap.Error(err),
				zap.Any("ItemMap", M),
			)
			return err
		}
	}
	return nil
}

func main() {
	var (
		h = &SnsHandler{}
	)
	l, _ := zap.NewProduction()
	defer zap.ReplaceGlobals(l)()
	if table := os.Getenv("DDB_TABLE_NAME"); table == "" {
		zap.L().Fatal("DDB_TABLE_NAME is required but unset")
	} else {
		h.TableName = table
	}
	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		zap.L().Fatal("Couldn't load AWS config",
			zap.Error(err),
		)
	}

	h.c = dynamodb.NewFromConfig(cfg)
	if ttl := os.Getenv("TTL_DURATION"); ttl != "" {
		h.ExpireAfter, err = time.ParseDuration(ttl)
		if err != nil {
			zap.L().Fatal("TTL_DURATION provided but failed to parse",
				zap.Error(err),
			)
		}
	} else {
		h.ExpireAfter = time.Hour * 24 * 7
	}

	lambda.Start(h.Handle)

}
