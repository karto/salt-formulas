{% from "security/pf/map.jinja" import pf with context %}

security/pf/service/pre:
  test.succeed_without_changes:
    - require_in:
      - service: security/pf/service/pf
      - service: security/pf/service/pflog

security/pf/service:
  test.succeed_without_changes:
    - require:
      - service: security/pf/service/pf
      - service: security/pf/service/pflog
    - watch:
      - service: security/pf/service/pf
      - service: security/pf/service/pflog


security/pf/service/pf:
  service.running:
    - name: pf
    - enable: True

security/pf/service/pflog:
  service.running:
    - name: pflog
    - enable: True

