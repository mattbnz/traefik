# syntax=docker/dockerfile:1.2
FROM alpine:3.20 as builder
RUN apk add --no-cache --no-progress git
RUN git clone --branch v0.0.1 https://github.com/jdel/staticresponse.git staticresponse
RUN rm -rf staticresponse/.git

FROM alpine:3.20

RUN apk add --no-cache --no-progress ca-certificates tzdata

ARG TARGETPLATFORM
COPY ./dist/$TARGETPLATFORM/traefik /

# Cache desired plugins locally to avoid network pull on startup.
RUN mkdir -p /plugins-local
COPY --from=builder staticresponse /plugins-local/src/github.com/jdel/staticresponse/
EXPOSE 80
VOLUME ["/tmp"]

ENTRYPOINT ["/traefik"]
