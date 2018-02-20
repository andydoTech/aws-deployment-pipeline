FROM golang:1.7.3
WORKDIR /src/
RUN go get -u github.com/golang/lint/golint
COPY . .
RUN golint -set_exit_status \
 && go test \
 && CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

FROM alpine:latest  
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=0 /src/app .
CMD ["./app"]  
