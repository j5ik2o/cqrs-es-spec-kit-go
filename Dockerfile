# syntax=docker/dockerfile:1
FROM golang:1.25 AS build
ARG TARGETARCH
COPY . /app
WORKDIR /app

RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go build -o /cqrs-es-spec-kit-go

FROM gcr.io/distroless/base-debian11

WORKDIR /

COPY --from=build /cqrs-es-spec-kit-go /cqrs-es-spec-kit-go

EXPOSE 8080

USER nonroot:nonroot

ENTRYPOINT ["/cqrs-es-spec-kit-go"]
