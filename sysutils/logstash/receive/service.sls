{% from "logstash/map.jinja" import logstash with context %}

logstash/receive/service:
  service.running:
    - name: logstash-receive
    - enable: True

# reload: pkill -HUP -f "java.*logstash"
