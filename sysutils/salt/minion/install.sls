{% from "sysutils/salt/minion/map.jinja" import salt_minion with context %}

sysutils/salt/minion/install:
  pkg.installed:
    - name: {{ salt_minion.lookup.pkg }}
    