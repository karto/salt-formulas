{% from "databases/postgresql/map.jinja" import postgresql with context %}
{% import 'statehelper.sls' as statehelper %}

databases/postgresql/config/pre:
  test.succeed_without_changes:
    - require_in:
      - file: databases/postgresql/config/file
      - file: databases/postgresql/config/pg_hba
      - file: databases/postgresql/config/recovery

databases/postgresql/config:
  test.succeed_without_changes:
    - require:
      - file: databases/postgresql/config/file
      - file: databases/postgresql/config/pg_hba
      - file: databases/postgresql/config/recovery
    - watch:
      - file: databases/postgresql/config/file
      - file: databases/postgresql/config/pg_hba
      - file: databases/postgresql/config/recovery


databases/postgresql/config/file:
  file.managed:
    - name: {{ postgresql.lookup.config_file }}
    - source:
        {{ statehelper.statesource("databases/postgresql", "postgresql.conf")|indent(6) }}
    - user: pgsql
    - group: pgsql
    - template: jinja
    - defaults:
        postgresql: {{ postgresql }}


databases/postgresql/config/pg_hba:
  file.managed:
    - name: {{ postgresql.lookup.pg_hba_file }}
    - source:
        {{ statehelper.statesource("databases/postgresql", "pg_hba.conf")|indent(6) }}
    - user: pgsql
    - group: pgsql
    - template: jinja
    - defaults:
        postgresql: {{ postgresql }}


{% if grains.fqdn != postgresql.primary_server %}

databases/postgresql/config/recovery:
  file.managed:
    - name: {{ postgresql.lookup.recovery_file }}
    - source:
        {{ statehelper.statesource("databases/postgresql", "recovery.conf")|indent(6) }}
    - user: pgsql
    - group: pgsql
    - template: jinja
    - defaults:
        postgresql: {{ postgresql }}

{% else %}

databases/postgresql/config/recovery:
  file.absent:
    - name: {{ postgresql.lookup.recovery_file }}

{% endif %}

databases/postgresql/config/pgpass:
  file.managed:
    - name: {{ postgresql.lookup.pgpass_file }}
    - source:
        {{ statehelper.statesource("databases/postgresql", "pgpass")|indent(6) }}
    - user: pgsql
    - group: pgsql
    - mode: 0600
    - template: jinja
    - defaults:
        postgresql: {{ postgresql }}


