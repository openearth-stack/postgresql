#!/bin/bash

if [ ! -f {{ postgresql_data_directory }}/PG_VERSION ]; then
        echo "The databases are not there."
        echo "I'll create it for you"
        mkdir -p {{ postgresql_data_directory }}
        chown postgres {{ postgresql_data_directory }}
        sudo -u postgres /usr/lib/postgresql/{{ postgresql_version }}/bin/initdb -D /var/lib/postgresql/{{ postgresql_version }}/main
        echo "Starting postgresql"
        sudo -u postgres /usr/lib/postgresql/{{ postgresql_version }}/bin/postgres -D {{ postgresql_data_directory }} -c config_file=/etc/postgresql/{{ postgresql_version }}/main/postgresql.conf &
        #create the database using the ansible tasks
        ansible-playbook -i inventory --become -c local tests/playbook.yml
        sudo -u postgres /usr/lib/postgresql/{{postgresql_version}}/bin/pg_ctl stop -D {{postgresql_data_directory}}
	sudo -u postgres /usr/lib/postgresql/{{ postgresql_version }}/bin/postgres -D {{ postgresql_data_directory }} -c config_file=/etc/postgresql/{{ postgresql_version }}/main/postgresql.conf 
else
        echo "The databases exist starting postgres"
        sudo -u postgres /usr/lib/postgresql/{{ postgresql_version }}/bin/postgres -D  {{ postgresql_data_directory }} -c config_file=/etc/postgresql/{{ postgresql_version }}/main/postgresql.conf
fi

