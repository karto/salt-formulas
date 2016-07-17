
include:
  - sysutils.rsyslog.pkg
  - sysutils.rsyslog.conf
  - sysutils.rsyslog.service

extend:
  sysutils/rsyslog/conf/pre:
    test.succeed_without_changes:
      - require:
        - pkg: sysutils/rsyslog/pkg
      - watch:
        - pkg: sysutils/rsyslog/pkg
  
  sysutils/rsyslog/service:
    service.running:
      - require:
        - test: sysutils/rsyslog/conf
      - watch:
        - test: sysutils/rsyslog/conf
