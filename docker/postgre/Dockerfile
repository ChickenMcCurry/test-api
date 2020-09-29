FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y \
    postgresql \
    postgresql-client \
    postgresql-contrib \
    sudo

ENV PG_USER="postgres" \
    PG_HOME="/var/lib/postgresql" \
    PG_CONF_DIR="/etc/postgresql/10/main" \
    PG_BIN_DIR="/usr/lib/postgresql/10/bin" \
    PG_RUN_DIR="/var/run/postgresql"\
    PG_TRUST_LOCALNET="true"\
    PG_LOG_DIR="/var/log/postgresql"\
    PG_DATA_DIR="/var/lib/postgresql/10/main"

RUN ln -sf ${PG_DATA_DIR}/postgresql.conf /etc/postgresql/10/main/postgresql.conf \
 && ln -sf ${PG_DATA_DIR}/pg_hba.conf /etc/postgresql/10/main/pg_hba.conf \
 && ln -sf ${PG_DATA_DIR}/pg_ident.conf /etc/postgresql/10/main/pg_ident.conf \
 && chmod -R 644 ${PG_CONF_DIR} && chown -R postgres:postgres ${PG_CONF_DIR} \
 && rm -rf ${PG_HOME}

COPY docker-entrypoint.sh docker-entrypoint.sh
RUN chmod 755 docker-entrypoint.sh
EXPOSE 5432/tcp

ENTRYPOINT ["/docker-entrypoint.sh"]
