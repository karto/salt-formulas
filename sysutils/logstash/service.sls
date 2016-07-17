{% from "sysutils/logstash/map.jinja" import logstash with context %}

sysutils/logstash/service:
  service.running:
    - name: {{ logstash.lookup.service }}
    - enable: True

# reload: pkill -HUP -f "java.*logstash"
