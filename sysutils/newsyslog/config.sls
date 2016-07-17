{% from "sysutils/newsyslog/map.jinja" import newsyslog with context %}
{% import 'statehelper.sls' as statehelper %}

sysutils/newsyslog/config/pre:
  test.succeed_without_changes:
    - require_in:
      - file: sysutils/newsyslog/config/dir

sysutils/newsyslog/config:
  test.succeed_without_changes:
    - require:
      - file: sysutils/newsyslog/config/dir
    - watch:
      - file: sysutils/newsyslog/config/dir

{#
sysutils/newsyslog/config/file:
  file.managed:
    - name: {{ newsyslog.lookup.config_file }}
    - source:
        {{ statehelper.statesource("sysutils/newsyslog", "newsyslog.conf")|indent(6) }}
    - template: jinja
    - defaults:
        newsyslog: {{ newsyslog }}
#}

sysutils/newsyslog/config/dir:
  file.recurse:
    - name: {{ newsyslog.lookup.config_dir }}
    - source:
        {{ statehelper.statesource("sysutils/newsyslog", "conf.d")|indent(6) }}
    - exclude_pat: "E@(^|/)\\._|\\.sample$"
    - keep_symlinks: true
    - include_empty: true
    - template: jinja
    - defaults:
        newsyslog: {{ newsyslog }}
