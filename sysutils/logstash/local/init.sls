
include:
  - sysutils.logstash.local.install
  - sysutils.logstash.local.config
  - sysutils.logstash.local.service



extend:
  sysutils/logstash/local/config/pre:
    test.succeed_without_changes:
      - require:
        - test: sysutils/logstash/local/install
      - watch:
        - test: sysutils/logstash/local/install
  
  sysutils/logstash/local/service:
    service.running:
      - require:
        - test: sysutils/logstash/local/conf
#      - watch:
#        - test: sysutils/logstash/local/conf



