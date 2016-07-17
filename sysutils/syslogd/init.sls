
include:
  - sysutils.syslogd.config
  - sysutils.syslogd.service


extend:
  sysutils/syslogd/service:
    service.running:
      - require:
        - test: sysutils/syslogd/config
      - watch:
        - test: sysutils/syslogd/config
