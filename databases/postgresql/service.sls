{% from "databases/postgresql/map.jinja" import postgresql with context %}

databases/postgresql/service:
  service.running:
    - name: {{ postgresql.lookup.service }}
    - enable: True
    - reload: True
