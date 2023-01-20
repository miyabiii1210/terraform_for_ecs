FROM golang:1.18.2-buster

WORKDIR /app
RUN mkdir ./proto ./go
COPY proto/ ./proto/
COPY go/ ./go/
COPY script_exec.sh /app/
RUN chmod 744 /app/script_exec.sh
RUN cd ./go && go mod download

CMD ["/app/script_exec.sh"]
