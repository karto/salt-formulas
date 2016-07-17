{% from "security/pf/map.jinja" import pf with context %}
{% import 'statehelper.sls' as statehelper %}

security/pf/config/pre:
  test.succeed_without_changes:
    - require_in:
      - file: security/pf/config/file

security/pf/config:
  test.succeed_without_changes:
    - require:
      - file: security/pf/config/file
    - watch:
      - file: security/pf/config/file


security/pf/config/file:
  file.managed:
    - name: {{ pf.lookup.config_file }}
    - source:
        {{ statehelper.statesource("security/pf", "pf.conf")|indent(6) }}
    - template: jinja
    - defaults:
        pf: {{ pf }}

