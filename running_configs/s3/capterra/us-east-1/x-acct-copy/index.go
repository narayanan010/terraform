package main

import (
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/credentials/stscreds"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	s3types "github.com/aws/aws-sdk-go-v2/service/s3/types"
	"github.com/aws/aws-sdk-go-v2/service/sts"
	"go.uber.org/zap"

	"context"
	"log"
	"os"
	"path"
)

var (
	DestinationBucket = os.Getenv("DESTINATION_BUCKET")
	DestinationPrefix = os.Getenv("DESTINATION_PREFIX")
	DestinationRole   = os.Getenv("DESTINATION_ROLE")
	DestinationRegion = os.Getenv("DESTINATION_REGION")

	s3src *s3.Client
	s3dst *s3.Client
)

func handler(ctx context.Context, s3Event events.S3Event) error {
	var failure error
	for _, record := range s3Event.Records {
		bucket := record.S3.Bucket.Name
		key := record.S3.Object.URLDecodedKey
		version := record.S3.Object.VersionID
		log.Printf("=== INFO: BucketName:%s ObjectKey:%d", bucket, key)
		log.Printf("=== INFO: VersionID:%s", version)

		zap.L().Info("Got new event",
			zap.String("EventSource", record.EventSource),
			zap.String("AWSRegion", record.AWSRegion),
			zap.String("EventName", record.EventName),
			zap.String("S3.Bucket", record.S3.Bucket.Name),
			zap.String("S3.Object.Key", record.S3.Object.Key),
			//zap.String("S3.Object.VersionID", record.S3.Object.VersionID),
			zap.String("S3.Object.VersionID", ""),
		)

		src := &s3.GetObjectInput{
			Bucket: &record.S3.Bucket.Name,
			Key:    &record.S3.Object.Key,
		}
		// if record.S3.Object.VersionID != "" {
		// 	src.VersionId = &record.S3.Object.VersionID
		// 	//src.VersionId = nil
		// }
		req, err := s3src.GetObject(ctx, src)
		if err != nil {
			failure = err
			zap.L().Error("Error getting object from source", zap.Error(err))
			continue // continue, but exit will be an error
		}
		dst := &s3.PutObjectInput{
			ACL:             s3types.ObjectCannedACLBucketOwnerFullControl,
			Body:            req.Body,
			Bucket:          aws.String(DestinationBucket),
			ContentEncoding: req.ContentEncoding,
			ContentType:     req.ContentType,
			ContentLength:   req.ContentLength,
			// Can't actually do this, as src only has ETag which is not
			// *necessarily* MD5 :(
			// ContentMD5:           req.ContentMD5,
			ServerSideEncryption: s3types.ServerSideEncryptionAes256,
		}
		if DestinationPrefix == "" {
			dst.Key = src.Key
		} else {
			dst.Key = aws.String(path.Join(DestinationPrefix, *src.Key))
		}
		_, err = s3dst.PutObject(ctx, dst)
		if err != nil {
			failure = err
			zap.L().Error("Error putting object to destination", zap.Error(err))
			continue // continue, but exit will be an error
		}
		_, err = s3src.DeleteObject(ctx, &s3.DeleteObjectInput{
			Bucket: &record.S3.Bucket.Name,
			Key:    &record.S3.Object.Key,
		})
		if err != nil {
			failure = err
			zap.L().Error("Error deleting source object", zap.Error(err))
			continue // continue, but exit will be an error
		}
	}
	return failure
}

func main() {
	z, _ := zap.NewProduction()
	defer zap.ReplaceGlobals(z)()
	srcCfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		log.Fatalf("unable to load SDK config, %v", err)
		zap.L().Fatal("Couldn't construct source config", zap.Error(err))
	}

	roleProvider := stscreds.NewAssumeRoleProvider(sts.NewFromConfig(srcCfg), DestinationRole)

	dstCfg, err := config.LoadDefaultConfig(context.TODO(),
		config.WithRegion(DestinationRegion),
		config.WithCredentialsProvider(
			aws.NewCredentialsCache(
				roleProvider,
			),
		),
	)

	if err != nil {
		zap.L().Fatal("Couldn't construct destination config", zap.Error(err))
	}

	s3src = s3.NewFromConfig(srcCfg)
	s3dst = s3.NewFromConfig(dstCfg)

	// Make the handler available for Remote Procedure Call by AWS Lambda
	lambda.Start(handler)
}
