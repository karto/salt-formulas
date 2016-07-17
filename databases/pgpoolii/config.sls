{% from "databases/pgpoolii/map.jinja" import pgpoolii with context %}
{% import 'statehelper.sls' as statehelper %}

databases/pgpoolii/config/pre:
  test.succeed_without_changes:
    - require_in:
      - file: databases/pgpoolii/config/file
      - file: databases/pgpoolii/config/pool_hba
      - file: databases/pgpoolii/config/pcp
      - file: databases/pgpoolii/config/pool_passwd

databases/pgpoolii/config:
  test.succeed_without_changes:
    - require:
      - file: databases/pgpoolii/config/file
      - file: databases/pgpoolii/config/pool_hba
      - file: databases/pgpoolii/config/pcp
      - file: databases/pgpoolii/config/pool_passwd
    - watch:
      - file: databases/pgpoolii/config/file
      - file: databases/pgpoolii/config/pool_hba
      - file: databases/pgpoolii/config/pcp
      - file: databases/pgpoolii/config/pool_passwd


databases/pgpoolii/config/file:
  file.managed:
    - name: {{ pgpoolii.lookup.config_file }}
    - source:
        {{ statehelper.statesource("databases/pgpoolii", "pgpool.conf")|indent(6) }}
    - template: jinja
    - defaults:
        pgpoolii: {{ pgpoolii }}

databases/pgpoolii/config/pool_hba:
  file.managed:
    - name: {{ pgpoolii.lookup.pool_hba_file }}
    - source:
        {{ statehelper.statesource("databases/pgpoolii", "pool_hba.conf")|indent(6) }}
    - template: jinja
    - defaults:
        pgpoolii: {{ pgpoolii }}

databases/pgpoolii/config/pcp:
  file.managed:
    - name: {{ pgpoolii.lookup.pcp_file }}
    - source:
        {{ statehelper.statesource("databases/pgpoolii", "pcp.conf")|indent(6) }}
    - template: jinja
    - defaults:
        pgpoolii: {{ pgpoolii }}

databases/pgpoolii/config/pool_passwd:
  file.managed:
    - name: {{ pgpoolii.lookup.pool_passwd_file }}
    - source:
        {{ statehelper.statesource("databases/pgpoolii", "pool_passwd")|indent(6) }}
    - user: nobody
    - group: pgsql
    - mode: 0660
    - template: jinja
    - defaults:
        pgpoolii: {{ pgpoolii }}

