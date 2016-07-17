{% from "sysutils/rsyslog/map.jinja" import rsyslog with context %}

sysutils/rsyslog/service:
  service.running:
    - name: {{ rsyslog.lookup.service }}
    - enable: True
