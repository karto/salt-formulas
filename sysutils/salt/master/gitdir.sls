{% from "sysutils/salt/master/map.jinja" import salt_master with context %}
{% import 'statehelper.sls' as statehelper %}

sysutils/salt/master/gitdir/pre:
  test.succeed_without_changes

sysutils/salt/master/gitdir:
  test.succeed_without_changes:
    - require:
      - test: sysutils/salt/master/gitdir/pre
    - watch:
      - test: sysutils/salt/master/gitdir/pre


sysutils/salt/master/gitdir/git:
  git.latest:
    - name: {{ salt_master.git_url }}
    - target: {{ salt_master.lookup.git_dir }}
    - identity:
        {{ statehelper.statesource("sysutils/salt/master", "salt_devops-udv_rsa")|indent(6) }}
    - template: jinja
    - defaults:
        salt: {{ salt }}
    - require:
      - test: sysutils/salt/master/gitdir/pre
    - require_in:
      - test: sysutils/salt/master/gitdir
    - watch_in:
      - test: sysutils/salt/master/gitdir
    