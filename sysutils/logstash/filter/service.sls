{% from "logstash/map.jinja" import logstash with context %}

logstash/filter/service:
  service.running:
    - name: logstash-filter
    - enable: True

# reload: pkill -HUP -f "java.*logstash"
