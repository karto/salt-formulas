
include:
  - logstash.receive.pkg
  - logstash.receive.conf
  - logstash.receive.service



extend:
  logstash/receive/conf/pre:
    test.succeed_without_changes:
      - require:
        - test: logstash/receive/pkg
      - watch:
        - test: logstash/receive/pkg
  
  logstash/receive/service:
    service.running:
      - require:
        - test: logstash/receive/conf
#      - watch:
#        - test: logstash/receive/conf



