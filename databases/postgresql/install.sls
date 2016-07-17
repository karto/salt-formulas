{% from "databases/postgresql/map.jinja" import postgresql with context %}

databases/postgresql/install/pre:
  test.succeed_without_changes:
    - require_in:
      - pkg: databases/postgresql/install/pkg

databases/postgresql/install:
  test.succeed_without_changes:
    - require:
      - pkg: databases/postgresql/install/pkg
    - watch:
      - pkg: databases/postgresql/install/pkg



databases/postgresql/install/pkg:
  pkg.installed:
    - name: {{ postgresql.lookup.pkg }}

{% if grains['os'] == 'FreeBSD' %}

databases/postgresql/install/initdb:
  cmd.run:
    - name: /usr/local/etc/rc.d/postgresql oneinitdb
    - creates: /usr/local/pgsql/data
    - require:
      - test: databases/postgresql/install/pre
    - require_in:
      - test: databases/postgresql/install
    - watch_in:
      - test: databases/postgresql/install

{% endif %}

