{% from "sysutils/salt/master/map.jinja" import salt_master with context %}


sysutils/salt/master/config/pre:
  test.succeed_without_changes:
    - require_in:
      - service: sysutils/salt/master/service/service

sysutils/salt/master/config:
  test.succeed_without_changes:
    - require:
      - test: sysutils/salt/master/config/pre
      - service: sysutils/salt/master/service/service
    - watch:
      - test: sysutils/salt/master/config/pre
      - service: sysutils/salt/master/service/service


sysutils/salt/master/service/service:
  service.running:
    - name: {{ salt_master.lookup.service }}
    - enable: True
