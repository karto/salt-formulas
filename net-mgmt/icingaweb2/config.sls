{% from "net-mgmt/icingaweb2/map.jinja" import icingaweb2 with context %}
{% import 'statehelper.sls' as statehelper %}

net-mgmt/icingaweb2/config/pre:
  test.succeed_without_changes:
    - require_in:
      - file: net-mgmt/icingaweb2/config/file

net-mgmt/icingaweb2/config:
  test.succeed_without_changes:
    - require:
      - file: net-mgmt/icingaweb2/config/file
    - watch:
      - file: net-mgmt/icingaweb2/config/file


net-mgmt/icingaweb2/config/file:
  file.managed:
    - name: {{ icingaweb2.lookup.config_file }}
    - source:
        {{ statehelper.statesource("net-mgmt/icingaweb2", "icingaweb2.conf")|indent(6) }}
    - template: jinja
    - defaults:
        icingaweb2: {{ icingaweb2 }}


