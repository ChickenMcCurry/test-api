FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && \
    apt -y upgrade && \
    apt-get install -y \
    curl \
    nginx && \
    rm -rf /var/lib/apt/lists/*

COPY nginx.conf /etc/nginx/nginx.conf
RUN chown www-data:www-data /var/www -R
RUN chown -R www-data:www-data /var/lib/nginx
RUN mkdir -p /var/www/test-api/dist

EXPOSE 8080

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
WORKDIR /var/www/test-api

USER www-data

CMD ["/docker-entrypoint.sh"]
