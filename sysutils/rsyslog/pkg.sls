{% from "sysutils/rsyslog/map.jinja" import rsyslog with context %}

sysutils/rsyslog/pkg:
  pkg.installed:
    - name: {{ rsyslog.lookup.pkg }}


