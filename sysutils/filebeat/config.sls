{% from "sysutils/filebeat/map.jinja" import filebeat with context %}
{% import 'statehelper.sls' as statehelper %}

sysutils/filebeat/config/pre:
  test.succeed_without_changes

sysutils/filebeat/config:
  test.succeed_without_changes:
    - require:
      - test: sysutils/filebeat/config/pre
    - watch:
      - test: sysutils/filebeat/config/pre


sysutils/filebeat/config/file:
  file.managed:
    - name: {{ filebeat.lookup.config_file }}
    - source:
        {{ statehelper.statesource("sysutils/filebeat", "filebeat.yml")|indent(6) }}
    - template: jinja
    - defaults:
        filebeat: {{ filebeat }}
    - require:
      - test: sysutils/filebeat/config/pre
    - require_in:
      - test: sysutils/filebeat/config
    - watch_in:
      - test: sysutils/filebeat/config

sysutils/filebeat/config/dir:
  file.recurse:
    - name: {{ filebeat.lookup.config_dir }}
    - source:
        {{ statehelper.statesource("sysutils/filebeat", "conf.d")|indent(6) }}
    - clean: true
    - exclude_pat: "E@(^|/)\\._|\\.sample$"
    - template: jinja
    - defaults:
        filebeat: {{ filebeat }}
    - require:
      - test: sysutils/filebeat/config/pre
    - require_in:
      - test: sysutils/filebeat/config
    - watch_in:
      - test: sysutils/filebeat/config
