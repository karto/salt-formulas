{% from "sysutils/syslogd/map.jinja" import syslogd with context %}

sysutils/syslogd/service:
  service.running:
    - name: {{ syslogd.lookup.service }}
    - enable: True
    - reload: True
