{% from "security/vault/map.jinja" import vault with context %}
{% import 'statehelper.sls' as statehelper %}

security/vault/config/pre:
  test.succeed_without_changes:
    - require_in:
      - file: security/vault/config/file

security/vault/config:
  test.succeed_without_changes:
    - require:
      - file: security/vault/config/file
    - watch:
      - file: security/vault/config/file


security/vault/config/file:
  file.managed:
    - name: {{ vault.lookup.config_file }}
    - source:
        {{ statehelper.statesource("security/vault", "vault.hcl")|indent(6) }}
    - template: jinja
    - defaults:
        vault: {{ vault }}
