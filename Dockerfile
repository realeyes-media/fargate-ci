FROM golang:1.11-alpine3.8 AS fargate

RUN apk update && apk add git
RUN go get github.com/jpignata/fargate
RUN cd /go/src/github.com/jpignata/fargate && env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -ldflags "-extldflags '-static'" -a -installsuffix cgo -o /usr/local/bin/fargate

FROM quay.io/realeyes/alpine-node-git:latest
COPY --from=fargate /usr/local/bin/fargate /usr/local/bin/fargate
RUN apk update && apk add docker
CMD ["fargate", "--version"]
