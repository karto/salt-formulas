{% from "sysutils/syslogd/map.jinja" import syslogd with context %}
{% import 'statehelper.sls' as statehelper %}

sysutils/syslogd/config/pre:
  test.succeed_without_changes:
    - require_in:
      - file: sysutils/syslogd/config/file

sysutils/syslogd/config:
  test.succeed_without_changes:
    - require:
      - file: sysutils/syslogd/config/file
    - watch:
      - file: sysutils/syslogd/config/file

{#
#sysutils/syslogd/config/file:
#  file.managed:
#    - name: {{ syslogd.lookup.config_file }}
#    - source:
#        {#{ statehelper.statesource("sysutils/syslogd", "syslog.conf")|indent(6) }#}
#    - template: jinja
#    - defaults:
#        syslogd: {{ syslogd }}
#}

sysutils/syslogd/config/file:
  file.uncomment:
    - name: {{ syslogd.lookup.config_file }}
    - regex: '^\*\.\*\s+/var/log/all.log$'

{% if syslogd.lookup.flags %}
sysutils/syslogd/config/rc:
  file.managed:
    - name: /etc/rc.conf.d/syslogd
    - contents: syslogd_flags="{{ syslogd.lookup.flags }}"
    - require:
      - test: sysutils/syslogd/config/pre
    - require_in:
      - test: sysutils/syslogd/config
    - watch_in:
      - test: sysutils/syslogd/config
{% endif %}

