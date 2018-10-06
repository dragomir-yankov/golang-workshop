# Stage 1. Build the binary
FROM golang:1.11

# add a non-privileged user
RUN useradd -u 10001 myapp

RUN mkdir -p /go/src/github.com/dragomir-yankov/golang-workshop
ADD . /go/src/github.com/dragomir-yankov/golang-workshop
WORKDIR /go/src/github.com/dragomir-yankov/golang-workshop

# build the binary with go build
RUN CGO_ENABLED=0 go build \
	-o bin/golang-workshop github.com/dragomir-yankov/golang-workshop/cmd/golang-workshop

# Stage 2. Run the binary
FROM scratch

ENV PORT 8080

COPY --from=0 /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

COPY --from=0 /etc/passwd /etc/passwd
USER myapp

COPY --from=0 /go/src/github.com/dragomir-yankov/golang-workshop/bin/golang-workshop /golang-workshop
EXPOSE $PORT

CMD ["/golang-workshop"]