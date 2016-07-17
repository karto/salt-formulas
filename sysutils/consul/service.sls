{% from "sysutils/consul/map.jinja" import consul with context %}

sysutils/consul/service:
  service.running:
    - name: {{ consul.lookup.service }}
    - enable: True
