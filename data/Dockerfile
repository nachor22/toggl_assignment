FROM golang:1.14 AS builder

WORKDIR /go/src/api
COPY SRE_Assignment/api/src/api/ .

RUN go get -d -v ./...
RUN CGO_ENABLED=0 GOOS=linux go install -v ./...

FROM alpine
WORKDIR /bin
COPY --from=builder /go/bin/api  /bin/api

CMD ["api"]
