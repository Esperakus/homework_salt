postgres_repo:
    pkg.installed:
        - name: pgdg-redhat-repo
        - enabled: true
        - sources:
          - pgdg-redhat-repo: https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm
        - gpgcheck: 0

remove_module:
    cmd.run:
        - name: dnf -qy module disable postgresql

postgresql13-server:
    pkg:
        - installed

init-db:
    cmd.run:
        - name: sudo /usr/pgsql-13/bin/postgresql-13-setup initdb
        - unless:
            - ls /var/lib/pgsql/13/data/postgresql.conf

postgresql.conf:
    file.managed:
        - name: /var/lib/pgsql/13/data/postgresql.conf
        - source: salt://postgres/postgresql.conf
        - user: postgres
        - group: postgres

pg_hba.conf:
    file.managed:
        - name: /var/lib/pgsql/13/data/pg_hba.conf
        - source: salt://postgres/pg_hba.conf
        - user: postgres
        - group: postgres

postgresql-13:
    service.running:
        - enable: true
        - require:
            - file: /var/lib/pgsql/13/data/postgresql.conf
            - file: /var/lib/pgsql/13/data/pg_hba.conf
            - pkg: postgresql13-server

user_test:
    postgres_user.present:
        - name: 'test'
        - password: 'test'
        
db_test:
    postgres_database.present:
        - name: 'test'
        - owner: 'test'
    require:
        - postgres.user_create: user_test    
    
