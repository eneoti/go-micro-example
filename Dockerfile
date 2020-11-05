FROM alpine:3.12.1 as builder

COPY --from=golang:1.14-alpine /usr/local/go/ /usr/local/go/
ENV PATH="/usr/local/go/bin:${PATH}"
RUN apk --no-cache add make git gcc libtool musl-dev

RUN mkdir -p /home/golang

ENV GOPATH="/home/golang"

RUN mkdir -p ${GOPATH}/src ${GOPATH}/bin

WORKDIR $GOPATH/src/github.com/micro/examples/helloworld

COPY go.mod .
COPY go.sum .
# RUN go mod download


COPY . .
RUN make ; rm -rf $GOPATH/pkg/mod

RUN ls 

FROM alpine:3.12.1


RUN mkdir -p /home/app

WORKDIR /home/app

RUN apk add ca-certificates && \
    rm -rf /var/cache/apk/* /tmp/* && \
    [ ! -e /etc/nsswitch.conf ] && echo 'hosts: files dns' > /etc/nsswitch.conf

COPY --from=builder /home/golang/src/github.com/micro/examples/helloworld/helloworld .

ENV CORS_ALLOWED_HEADERS="*"
ENV CORS_ALLOWED_ORIGINS="*"
ENV CORS_ALLOWED_METHODS="GET,POST,PUT,PATCH,DELETE,OPTIONS"

ENV MICRO_SERVER_ADDRESS 0.0.0.0:8080

ENV MICRO_ENABLE_STATS true
ENV MICRO_BROKER nats
ENV MICRO_BROKER_ADDRESS nats-cluster
ENV MICRO_REGISTRY etcd
ENV MICRO_REGISTRY_ADDRESS etcd-cluster-client

ENV MICRO_REGISTER_TTL 60
ENV MICRO_REGISTER_INTERVAL 30
ENV MICRO_ENABLE_ACME false



CMD [ "./helloworld" ]

