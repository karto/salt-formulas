{% from "net-mgmt/collectd/map.jinja" import collectd with context %}
{% import 'statehelper.sls' as statehelper %}

net-mgmt/collectd/config/pre:
  test.succeed_without_changes:
    - require_in:
      - file: net-mgmt/collectd/config/file
      - file: net-mgmt/collectd/config/dir
      - file: net-mgmt/collectd/config/typesdb

net-mgmt/collectd/config:
  test.succeed_without_changes:
    - require:
      - file: net-mgmt/collectd/config/file
      - file: net-mgmt/collectd/config/dir
      - file: net-mgmt/collectd/config/typesdb
    - watch:
      - file: net-mgmt/collectd/config/file
      - file: net-mgmt/collectd/config/dir
      - file: net-mgmt/collectd/config/typesdb


net-mgmt/collectd/config/file:
  file.managed:
    - name: {{ collectd.lookup.config_file }}
    - source:
        {{ statehelper.statesource("net-mgmt/collectd", "collectd.conf")|indent(6) }}
    - template: jinja
    - defaults:
        collectd: {{ collectd }}


net-mgmt/collectd/config/dir:
  file.recurse:
    - name: {{ collectd.lookup.config_dir }}
    - source:
        {{ statehelper.statesource("net-mgmt/collectd", "conf.d")|indent(6) }}
    - clean: true
    - exclude_pat: "E@(^|/)\\._|\\.sample$"
    - include_empty: true
    - template: jinja
    - defaults:
        collectd: {{ collectd }}


net-mgmt/collectd/config/typesdb:
  file.managed:
    - name: {{ collectd.lookup.typesdb_file }}
    - source:
        {{ statehelper.statesource("net-mgmt/collectd", "types.db")|indent(6) }}
    - template: jinja
    - defaults:
        collectd: {{ collectd }}
