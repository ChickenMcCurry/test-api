#!/usr/bin/env bash
set -Eeo pipefail

if [ ! -z ${IN_MEMORY+x} ]; then
  echo "Enable Database In Memory"
fi

if [ -z ${DB_USER+x} ]; then
    export DB_USER=test
fi

if [  -z ${DB_NAME+x} ]; then
    export DB_NAME="test"
fi

if [ -z ${DB_PASS+x} ]; then
    export DB_PASS=test
fi
if [ -z ${PG_PASSWORD+x} ]; then
    export PG_PASSWORD=test
fi


#On execute les commandes avec le user Postgres
exec_as_postgres() {
  sudo -HEu ${PG_USER} "$@"
}

create_logdir() {
  echo "Initializing logdir..."
  mkdir -p ${PG_LOG_DIR}
  chmod -R 1775 ${PG_LOG_DIR}
  chown -R root:${PG_USER} ${PG_LOG_DIR}
}


create_datadir() {
  echo "Initializing datadir..."
  mkdir -p ${PG_HOME}
  if [[ -d ${PG_DATA_DIR} ]]; then
    find ${PG_DATA_DIR} -type f -exec chmod 0600 {} \;
    find ${PG_DATA_DIR} -type d -exec chmod 0700 {} \;
  fi
  chown -R ${PG_USER}:${PG_USER} ${PG_HOME}
}

create_rundir() {
  #On créé le docssier et fichier avec les bon droits
  echo "Initializing rundir..."
  mkdir -p ${PG_RUN_DIR} ${PG_RUN_DIR}/10-main.pg_stat_tmp
  chmod -R 0755 ${PG_RUN_DIR}
  chmod g+s ${PG_RUN_DIR}
  chown -R ${PG_USER}:${PG_USER} ${PG_RUN_DIR}
}

init_database() {
  #On test si le dossier de la BDD est vide
	if [ -n "$(ls -A /var/lib/postgresql/10/main 2>/dev/null)" ]; then
		echo "Database is not empty"
	else
    #On stock le MDP dans un fichier
		if [[ -n $PG_PASSWORD ]]; then
        	echo "${PG_PASSWORD}" > /tmp/pwfile
    	fi

    	exec_as_postgres ${PG_BIN_DIR}/initdb --pgdata=${PG_DATA_DIR} --username=${PG_USER} --encoding=unicode --auth=trust ${PG_PASSWORD:+--pwfile=/tmp/pwfile} >/dev/null

      #On supprime le fichier
      rm -rf /tmp/pwfile
	fi

  # On modifie le data_directory de la conf postgres
  set_postgresql_param "data_directory" "${PG_DATA_DIR}"

  # On modifie les logs de la conf postgres
  set_postgresql_param "log_directory" "${PG_LOG_DIR}"
  set_postgresql_param "log_filename" "postgresql-10-main.log"

  # On autorise les connections à la base de données
  set_hba_param "host all all 0.0.0.0/0 md5"

}

create_user() {
  #On test si la variable utilisateur est présente
  if [[ -n ${DB_USER} ]]; then
    #On test si la variable MDP est présente
    if [[ -z ${DB_PASS} ]]; then
        echo "ERROR! Please specify a password for DB_USER in DB_PASS. Exiting..."
        exit 1
    fi
    echo "Creating database user: ${DB_USER}"
    #On test si le user existe deja
    if [[ -z $(psql -U ${PG_USER} -Atc "SELECT 1 FROM pg_catalog.pg_user WHERE usename = '${DB_USER}'";) ]]; then
        psql -U ${PG_USER} -c "CREATE ROLE \"${DB_USER}\" with LOGIN CREATEDB PASSWORD '${DB_PASS}';" >/dev/null
    fi
  fi
}

create_database() {
  #On test si la variable est présente
  if [[ -n ${DB_NAME} ]]; then
    #On parcour la liste des BDD Stocké dans dans a variable Ex : BDD1 BDD2
    for database in $(awk -F',' '{for (i = 1 ; i <= NF ; i++) print $i}' <<< "${DB_NAME}"); do
        echo "Creating database: ${database}..."
        if [[ -z $(psql -U ${PG_USER} -Atc "SELECT 1 FROM pg_catalog.pg_database WHERE datname = '${database}'";) ]]; then
        	psql -U ${PG_USER} -c "CREATE DATABASE \"${database}\" WITH TEMPLATE = template1;" >/dev/null
        fi
        #On test si la variable user est présente
        if [[ -n ${DB_USER} ]]; then
        	echo "‣ Granting access to ${DB_USER} user..."
            psql -U ${PG_USER} -c "GRANT ALL PRIVILEGES ON DATABASE \"${database}\" to \"${DB_USER}\";" >/dev/null
        fi
    done
  fi
}

set_postgresql_param() {
  #On recupere les valeurs (Nom du parametre / valeur du parametre)
  local key=${1}
  local value=${2}
  #On test si on a bien une valeur
  if [[ -n ${value} ]]; then
    #On recupere la valeur actuelle
    local current=$(exec_as_postgres sed -n -e "s/^\(${key} = '\)\([^ ']*\)\(.*\)$/\2/p" ${PG_DATA_DIR}/postgresql.conf)
    #Si la nouvelle valeur est differente de l'ancienne alors on la sed
    if [[ "${current}" != "${value}" ]]; then
      value="$(echo "${value}" | sed 's|[&]|\\&|g')"
      exec_as_postgres sed -i "s|^[#]*[ ]*${key} = .*|${key} = '${value}'|" ${PG_DATA_DIR}/postgresql.conf
    fi
  fi
}

set_hba_param() {
  local value=${1}
  if ! grep -q "$(sed "s| | \\\+|g" <<< ${value})" ${PG_DATA_DIR}/pg_hba.conf; then
    echo "${value}" >> ${PG_DATA_DIR}/pg_hba.conf
  fi
}


create_logdir
create_datadir
echo "Create rundir"
create_rundir
echo "Init Database"
init_database
rm -rf ${PG_DATA_DIR}/postmaster.pid
set_postgresql_param "listen_addresses" "127.0.0.1" quiet
echo "Start Postgres"
exec_as_postgres ./${PG_BIN_DIR}/pg_ctl -D ${PG_DATA_DIR} -w start >/dev/null
echo "Create User"
create_user
echo "Create Database"
create_database
echo "Stop Postgres"
exec_as_postgres ${PG_BIN_DIR}/pg_ctl -D ${PG_DATA_DIR} -w stop >/dev/null
set_postgresql_param "listen_addresses" "*" quiet
echo "Starting PostgreSQL 10  ..."
exec start-stop-daemon --start --chuid ${PG_USER}:${PG_USER} \
    --exec ${PG_BIN_DIR}/postgres -- -D ${PG_DATA_DIR}
