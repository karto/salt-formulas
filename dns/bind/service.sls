{% from "bind/map.jinja" import bind with context %}

dns/bind/service:
  service.running:
    - name: {{ bind.lookup.service }}
    - enable: True
    - reload: True
