#!/bin/bash

if [ ! -f /var/lib/postgresql/9.6/main/PG_VERSION ]; then
        echo "The databases are not there."
        echo "I'll create it for you"
        mkdir -p /var/lib/postgresql/9.6/main
        chown postgres /var/lib/postgresql/9.6/main
        sudo -u postgres /usr/lib/postgresql/9.6/bin/initdb -D /var/lib/postgresql/9.6/main
        echo "Starting postgresql"
        sudo -u postgres /usr/lib/postgresql/9.6/bin/postgres -D /var/lib/postgresql/9.6/main/ -c config_file=/etc/postgresql/9.6/main/postgresql.conf &
        #create the database using the ansible tasks
        ansible-playbook -i inventory --become -c local tests/playbook.yml
else
        echo "The databases exist starting postgres"
        sudo -u postgres /usr/lib/postgresql/9.6/bin/postgres -D /var/lib/postgresql/9.6/main/ -c config_file=/etc/postgresql/9.6/main/postgresql.conf
fi

