{% from "net/natd/map.jinja" import natd with context %}
{% import 'statehelper.sls' as statehelper %}

net/natd/config/pre:
  test.succeed_without_changes:
    - require_in:
      - file: net/natd/config/file

net/natd/config:
  test.succeed_without_changes:
    - require:
      - file: net/natd/config/file
    - watch:
      - file: net/natd/config/file


net/natd/config/file:
  file.managed:
    - name: {{ natd.lookup.config_file }}
    - source:
        {{ statehelper.statesource("net/natd", "natd.conf")|indent(6) }}
    - template: jinja
    - defaults:
        natd: {{ natd }}
