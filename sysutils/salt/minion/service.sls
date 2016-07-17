{% from "sysutils/salt/minion/map.jinja" import salt_minion with context %}

sysutils/salt/minion/service:
  service.running:
    - name: {{ salt_minion.lookup.service }}
    - enable: True
