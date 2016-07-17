{% from "security/vault/map.jinja" import vault with context %}

security/vault/service:
  service.running:
    - name: {{ vault.lookup.service }}
    - enable: True
