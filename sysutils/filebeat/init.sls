
include:
  - sysutils.filebeat.install
  - sysutils.filebeat.config
  - sysutils.filebeat.service

extend:
  sysutils/filebeat/config/pre:
    test.succeed_without_changes:
      - require:
        - test: sysutils/filebeat/install
      - watch:
        - test: sysutils/filebeat/install
  
  sysutils/filebeat/service:
    service.running:
      - require:
        - test: sysutils/filebeat/config
      - watch:
        - test: sysutils/filebeat/config
