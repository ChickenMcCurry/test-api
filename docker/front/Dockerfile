FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

ARG USER_ID
ENV UID=$USER_ID

ARG GROUP_ID

RUN apt update && apt -y upgrade && apt-get install -y curl nginx unzip gnupg && \
    curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt install -y nodejs && \
    npm install -g forever && \
    rm -rf /var/lib/apt/lists/*

COPY host.conf /etc/nginx/sites-enabled/default
COPY nginx.conf /etc/nginx/nginx.conf

RUN addgroup --force-badname --gid $GROUP_ID $USER_ID

RUN adduser  --force-badname --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID $USER_ID

RUN usermod -s /bin/bash $USER_ID

RUN chown $USER_ID:$GROUP_ID /var/www -R
RUN chown -R $USER_ID:$GROUP_ID /var/lib/nginx
RUN chown -R $USER_ID:$GROUP_ID /var/log/nginx
RUN mkdir -p /var/www/front-app/build

RUN sed -i "s=__USER_ID__=${UID}=g" /etc/nginx/nginx.conf

EXPOSE 8080

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
WORKDIR /var/www/front-app

USER $USER_ID

CMD ["nginx", "-g", "daemon off;"]
