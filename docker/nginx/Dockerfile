FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

ARG USER_ID
ENV UID=$USER_ID

ARG GROUP_ID

RUN apt update && \
    apt -y upgrade && \
    apt-get install -y \
    curl \
    nginx && \
    rm -rf /var/lib/apt/lists/*

COPY nginx.conf /etc/nginx/nginx.conf
RUN chown $USER_ID:$GROUP_ID /var/www -R
RUN chown -R $USER_ID:$GROUP_ID /var/lib/nginx
RUN chown -R $USER_ID:$GROUP_ID /var/log/nginx
RUN mkdir -p /var/www/test-api/dist
RUN sed -i "s=__USER_ID__=${UID}=g" /etc/nginx/nginx.conf

EXPOSE 8080

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
WORKDIR /var/www/test-api

USER $USER_ID

CMD ["/docker-entrypoint.sh"]
