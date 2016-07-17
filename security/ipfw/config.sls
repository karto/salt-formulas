{% from "security/ipfw/map.jinja" import ipfw with context %}
{% import 'statehelper.sls' as statehelper %}

security/ipfw/config/pre:
  test.succeed_without_changes:
    - require_in:
      - file: security/ipfw/config/file

security/ipfw/config:
  test.succeed_without_changes:
    - require:
      - file: security/ipfw/config/file
    - watch:
      - file: security/ipfw/config/file


security/ipfw/config/file:
  file.managed:
    - name: {{ ipfw.lookup.config_file }}
    - source:
        {{ statehelper.statesource("security/ipfw", "ipfw.rules")|indent(6) }}
    - mode: 0775
    - template: jinja
    - defaults:
        ipfw: {{ ipfw }}
