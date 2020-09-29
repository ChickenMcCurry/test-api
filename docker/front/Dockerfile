FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && apt -y upgrade && apt-get install -y curl nginx unzip gnupg && \
    curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt install -y nodejs && \
    npm install -g forever && \
    rm -rf /var/lib/apt/lists/*

COPY host.conf /etc/nginx/sites-enabled/default
COPY nginx.conf /etc/nginx/nginx.conf
RUN chown www-data:www-data /var/www -R
RUN chown -R www-data:www-data /var/lib/nginx
RUN mkdir -p /var/www/front-app/build

EXPOSE 8080

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
WORKDIR /var/www/front-app

USER www-data

CMD ["nginx", "-g", "daemon off;"]
