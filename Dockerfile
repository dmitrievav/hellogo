FROM golang:latest as builder
RUN mkdir /app
ADD . /app/
WORKDIR /app
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

FROM scratch
COPY --from=builder /app/main .
ENV PORT 8080
EXPOSE 8080
CMD ["/main"]