{% from "sysutils/consul/map.jinja" import consul with context %}
{% import 'statehelper.sls' as statehelper %}

sysutils/consul/config/pre:
  test.succeed_without_changes:
    - require_in:
      - file: sysutils/consul/config/dir
      - file: sysutils/consul/config/rc

sysutils/consul/config:
  test.succeed_without_changes:
    - require:
      - file: sysutils/consul/config/dir
      - file: sysutils/consul/config/rc
    - watch:
      - file: sysutils/consul/config/dir
      - file: sysutils/consul/config/rc


sysutils/consul/config/dir:
  file.recurse:
    - name: {{ consul.lookup.config_dir }}
    - source:
        {{ statehelper.statesource("sysutils/consul", "consul.d")|indent(6) }}
    - clean: true
    - exclude_pat: "E@(^|/)\\._|\\.sample$"
    - keep_symlinks: true
    - include_empty: true
    - template: jinja
    - defaults:
        consul: {{ consul }}


sysutils/consul/config/rc:
  {% if consul.lookup.args %}
  file.managed:
    - name: /etc/rc.conf.d/consul
    - contents: consul_args="{{ consul.lookup.args }}"
  {% else %}
  file.absent:
    - name: /etc/rc.conf.d/consul
  {% endif %}
