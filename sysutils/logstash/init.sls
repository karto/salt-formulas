
include:
  - sysutils.logstash.install
  - sysutils.logstash.config
  - sysutils.logstash.service



extend:
  sysutils/logstash/config/pre:
    test.succeed_without_changes:
      - require:
        - test: sysutils/logstash/install
      - watch:
        - test: sysutils/logstash/install
  
  sysutils/logstash/service:
    service.running:
      - require:
        - test: sysutils/logstash/config
      - watch:
        - test: sysutils/logstash/config



