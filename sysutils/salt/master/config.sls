{% from "sysutils/salt/master/map.jinja" import salt_master with context %}
{% import 'statehelper.sls' as statehelper %}

sysutils/salt/master/config/pre:
  test.succeed_without_changes:
    - require_in:
      - file: sysutils/salt/master/config/file
      - file: sysutils/salt/master/config/rc_conf

sysutils/salt/master/config:
  test.succeed_without_changes:
    - require:
      - test: sysutils/salt/master/config/pre
      - file: sysutils/salt/master/config/file
      - file: sysutils/salt/master/config/rc_conf
    - watch:
      - test: sysutils/salt/master/config/pre
      - file: sysutils/salt/master/config/file
      - file: sysutils/salt/master/config/rc_conf


sysutils/salt/master/config/file:
  file.managed:
    - name: {{ salt_master.lookup.config_file }}
    - source:
        {{ statehelper.statesource("sysutils/salt/master", "master")|indent(6) }}
    - template: jinja
    - defaults:
        salt: {{ salt }}

{% if salt_master.lookup.config_dir %}
sysutils/salt/master/config/dir:
  file.recurse:
    - name: {{ salt_master.lookup.config_dir }}
    - source:
        {{ statehelper.statesource("sysutils/salt/master", "master.d")|indent(6) }}
    - clean: true
    - exclude_pat: "E@(^|/)\\._|\\.sample$"
    - keep_symlinks: true
    - template: jinja
    - defaults:
        salt: {{ salt }}
    - require:
      - test: sysutils/salt/master/config/pre
    - require_in:
      - test: sysutils/salt/master/config
    - watch_in:
      - test: sysutils/salt/master/config
{% endif %}


sysutils/salt/master/config/rc_conf:
  {% if salt_master.lookup.rc_conf %}
  file.managed:
    - name: /etc/rc.conf.d/salt_master
    - contents: {{ salt_master.lookup.rc_conf|yaml_encode }}
  {% else %}
  file.absent:
    - name: /etc/rc.conf.d/salt_master
  {% endif %}
