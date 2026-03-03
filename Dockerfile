### STAGE 1: Build ###

FROM golang:1-alpine as builder

WORKDIR /app
COPY . /app
RUN go install

### STAGE 2: Setup ###

FROM alpine
RUN apk add --no-cache \
  libc6-compat
COPY --from=builder /go/bin/golang_cicdactions_example /golang_cicdactions_example
RUN chmod +x /golang_cicdactions_example
ENTRYPOINT ["/golang_cicdactions_example"]