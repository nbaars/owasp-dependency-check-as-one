FROM azul/zulu-openjdk-alpine:16.0.1-16.30.15-jre@sha256:86e0257d78a25b91b5b75a6341db1ce070e1fb917da20148365e7d2c242f4e40 AS builder

WORKDIR /dependency-check
RUN apk add curl && \
    curl -L -o dependency-check-6.1.6-release.zip https://github.com/jeremylong/DependencyCheck/releases/download/v6.1.6/dependency-check-6.1.6-release.zip && \
    unzip dependency-check-6.1.6-release.zip && \
    dependency-check/bin/dependency-check.sh --data data -s .

FROM azul/zulu-openjdk-alpine:16.0.1-16.30.15-jre@sha256:86e0257d78a25b91b5b75a6341db1ce070e1fb917da20148365e7d2c242f4e40

LABEL org.opencontainers.image.authors="nanneb@gmail.com"

RUN addgroup -S owasp && adduser -S owasp -G owasp
USER owasp

WORKDIR /dependency-check
COPY --chown=owasp:owasp --from=builder /dependency-check/data data
COPY --chown=owasp:owasp --from=builder /dependency-check/dependency-check .
