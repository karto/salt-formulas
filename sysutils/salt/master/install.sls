{% from "sysutils/salt/master/map.jinja" import salt_master with context %}

sysutils/salt/master/install/pre:
  test.succeed_without_changes:
    - require_in:
      - pkg: sysutils/salt/master/install/pkg

sysutils/salt/master/install:
  test.succeed_without_changes:
    - require:
      - test: sysutils/salt/master/install/pre
      - pkg: sysutils/salt/master/install/pkg
    - watch:
      - test: sysutils/salt/master/install/pre
      - pkg: sysutils/salt/master/install/pkg


sysutils/salt/master/install/pkg:
  pkg.installed:
    - name: {{ salt_master.lookup.pkg }}


{% if grains['os'] == 'FreeBSD' %}

{% endif %}

