{% from "sysutils/consul/map.jinja" import consul with context %}

sysutils/consul/install/pre:
  test.succeed_without_changes:
    - require_in:
      - pkg: sysutils/consul/install/pkg

sysutils/consul/install:
  test.succeed_without_changes:
    - require:
      - pkg: sysutils/consul/install/pkg
    - watch:
      - pkg: sysutils/consul/install/pkg


sysutils/consul/install/pkg:
  pkg.installed:
    - name: {{ consul.lookup.pkg }}


{% if grains['os'] == 'FreeBSD' %}

{% endif %}

