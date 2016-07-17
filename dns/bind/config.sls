{% from "dns/bind/map.jinja" import bind with context %}
{% import 'statehelper.sls' as statehelper %}

dns/bind/config/pre:
  test.succeed_without_changes:
    - require_in:
      - file: dns/bind/config/file
      - file: dns/bind/config/master
      - file: dns/bind/config/dynamic

dns/bind/config:
  test.succeed_without_changes:
    - require:
      - file: dns/bind/config/file
      - file: dns/bind/config/master
      - file: dns/bind/config/dynamic
    - watch:
      - file: dns/bind/config/file
      - file: dns/bind/config/master
      - file: dns/bind/config/dynamic


dns/bind/config/file:
  file.managed:
    - name: {{ bind.lookup.config_file }}
    - source:
        {{ statehelper.statesource("dns/bind", "named.conf")|indent(6) }}
    - template: jinja
    - defaults:
        bind: {{ bind }}

dns/bind/config/master:
  file.recurse:
    - name: {{ bind.lookup.master_dir }}
    - source:
        {{ statehelper.statesource("dns/bind", "master")|indent(6) }}
    - clean: true
    - exclude_pat: "E@(^|/)\\._|\\.sample$"
    - include_empty: true
    - template: jinja
    - defaults:
        bind: {{ bind }}

dns/bind/config/dynamic:
  file.recurse:
    - name: {{ bind.lookup.dynamic_dir }}
    - source:
        {{ statehelper.statesource("dns/bind", "dynamic")|indent(6) }}
    - clean: true
    - exclude_pat: "E@(^|/)\\._|\\.sample$"
    - include_empty: true
    - template: jinja
    - defaults:
        bind: {{ bind }}


