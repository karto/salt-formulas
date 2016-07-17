{% from "sysutils/logstash/map.jinja" import logstash with context %}

sysutils/logstash/local/service:
  service.running:
    - name: logstash-local
    - enable: True

# reload: pkill -HUP -f "java.*logstash"
