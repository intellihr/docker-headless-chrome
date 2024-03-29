#
# First Stage
#
FROM alpine:3.8 AS pre

LABEL maintainer="intelliHR Support <support@intellihr.com.au>"
ENV REFRESHED_AT 2022-01-05

WORKDIR /tmp
RUN apk add --update make gcc g++ python curl yarn
RUN curl https://noto-website.storage.googleapis.com/pkgs/NotoSansCJKjp-hinted.zip -O
RUN unzip NotoSansCJKjp-hinted.zip

#
# Second Stage
#
FROM node:12.12.0-alpine3.14

COPY --from=pre /tmp/*.otf /usr/share/fonts/noto/

RUN echo "http://dl-2.alpinelinux.org/alpine/edge/main" > /etc/apk/repositories \
    && echo "http://dl-2.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && echo "http://dl-2.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk -U --no-cache --allow-untrusted add \
      python3 \
      make \
      g++ \
      udev \
      ttf-freefont \
      chromium \
      chromium-chromedriver \
      openjdk8-jre && \
    fc-cache -fv

RUN yarn global add node-gyp
