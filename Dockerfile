# Build image
FROM nginx:alpine

RUN apk add --no-cache stagit bash

RUN mkdir -p /var/www/html

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["bash", "/entrypoint.sh"]
