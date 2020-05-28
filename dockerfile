FROM golang:1.14.1-alpine3.11 as builder

RUN apk update && apk add --no-cache git ca-certificates tzdata && update-ca-certificates

WORKDIR $GOPATH/src/mypackage/myapp/
COPY . .

RUN go get -d -v

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
      -ldflags='-w -s -extldflags "-static"' -a \
      -o /go/bin/hello .

FROM scratch

COPY --from=builder /go/bin/hello /go/bin/hello

ENTRYPOINT ["/go/bin/hello"]