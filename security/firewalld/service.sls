{% from "security/firewalld/map.jinja" import firewalld with context %}

security/firewalld/service:
  service.running:
    - name: {{ firewalld.lookup.service }}
    - enable: True
