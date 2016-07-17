{% from "sysutils/rsyslog/map.jinja" import rsyslog with context %}
{% import 'statehelper.sls' as statehelper %}


sysutils/rsyslog/conf/pre:
  test.succeed_without_changes:
    - require_in:
{% if rsyslog.lookup.config_file %}
      - file: sysutils/rsyslog/conf/file
{% endif %}
      - file: sysutils/rsyslog/conf/dir
{% if grains['os'] == 'FreeBSD' %}
{% endif %}


sysutils/rsyslog/conf:
  test.succeed_without_changes:
    - require:
{% if rsyslog.lookup.config_file %}
      - file: sysutils/rsyslog/conf/file
{% endif %}
      - file: sysutils/rsyslog/conf/dir
{% if grains['os'] == 'FreeBSD' %}
{% endif %}
    - watch:
{% if rsyslog.lookup.config_file %}
      - file: sysutils/rsyslog/conf/file
{% endif %}
      - file: sysutils/rsyslog/conf/dir
{% if grains['os'] == 'FreeBSD' %}
{% endif %}

{% if rsyslog.lookup.config_file %}
sysutils/rsyslog/conf/file:
  file.managed:
    - name: {{ rsyslog.lookup.config_file }}
    - source:
        {{ statehelper.statesource("sysutils/rsyslog", "rsyslog.conf")|indent(6) }}
    - template: jinja
    - defaults:
        rsyslog: {{ rsyslog }}
{% endif %}


sysutils/rsyslog/conf/dir:
  file.recurse:
    - name: {{ rsyslog.lookup.config_dir }}
    - source:
        {{ statehelper.statesource("sysutils/rsyslog", "rsyslog.d")|indent(6) }}
    - exclude_pat: "E@(^|/)\\._|\\.sample$"
    - template: jinja
    - defaults:
        rsyslog: {{ rsyslog }}

