{% from "security/firewalld/map.jinja" import firewalld with context %}
{% import 'statehelper.sls' as statehelper %}

security/firewalld/conf/pre:
  test.succeed_without_changes:
    - require_in:
      - file: security/firewalld/conf/icmptypes
      - file: security/firewalld/conf/services
      - file: security/firewalld/conf/zones

security/firewalld/conf:
  test.succeed_without_changes:
    - require:
      - file: security/firewalld/conf/icmptypes
      - file: security/firewalld/conf/services
      - file: security/firewalld/conf/zones
    - watch:
      - file: security/firewalld/conf/icmptypes
      - file: security/firewalld/conf/services
      - file: security/firewalld/conf/zones


security/firewalld/conf/icmptypes:
  file.recurse:
    - name: {{ firewalld.lookup.icmptypes_dir }}
    - source:
        {{ statehelper.statesource("security/firewalld", "icmptypes")|indent(6) }}
    - clean: true
    - exclude_pat: "E@(^|/)\\._|\\.sample$"
    - template: jinja
    - defaults:
        firewalld: {{ firewalld }}


security/firewalld/conf/services:
  file.recurse:
    - name: {{ firewalld.lookup.services_dir }}
    - source:
        {{ statehelper.statesource("security/firewalld", "services")|indent(6) }}
    - clean: true
    - exclude_pat: "E@(^|/)\\._|\\.sample$"
    - template: jinja
    - defaults:
        firewalld: {{ firewalld }}


security/firewalld/conf/zones:
  file.recurse:
    - name: {{ firewalld.lookup.zones_dir }}
    - source:
        {{ statehelper.statesource("security/firewalld", "zones")|indent(6) }}
    - clean: true
    - exclude_pat: "E@(^|/)\\._|\\.sample$"
    - template: jinja
    - defaults:
        firewalld: {{ firewalld }}

