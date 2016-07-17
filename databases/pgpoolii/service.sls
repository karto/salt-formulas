{% from "databases/pgpoolii/map.jinja" import pgpoolii with context %}

databases/pgpoolii/service:
  service.running:
    - name: {{ pgpoolii.lookup.service }}
    - enable: True
    - reload: True
