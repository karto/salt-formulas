
include:
  - logstash.filter.pkg
  - logstash.filter.conf
  - logstash.filter.service



extend:
  logstash/filter/conf/pre:
    test.succeed_without_changes:
      - require:
        - test: logstash/filter/pkg
      - watch:
        - test: logstash/filter/pkg
  
  logstash/filter/service:
    service.running:
      - require:
        - test: logstash/filter/conf
#      - watch:
#        - test: logstash/filter/conf



