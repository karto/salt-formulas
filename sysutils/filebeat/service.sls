{% from "sysutils/filebeat/map.jinja" import filebeat with context %}

sysutils/filebeat/service:
  service.running:
    - name: {{ filebeat.lookup.service }}
    - enable: True
