FROM golang:1.19-alpine

WORKDIR /usr/src/
ADD go.* /usr/src/
RUN go mod download
ADD *.go /usr/src/
RUN go build -o ses-handler

FROM alpine
COPY --from=0 /usr/src/ses-handler /ses-handler
ENTRYPOINT ["/ses-handler"]
