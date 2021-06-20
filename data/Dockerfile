FROM golang:1.14

WORKDIR /go/src/api
COPY SRE_Assignment/api/src/api/ .

RUN go get -d -v ./...
RUN go install -v ./...

CMD ["api"]
