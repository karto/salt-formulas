{% from "security/firewalld/map.jinja" import firewalld with context %}

security/firewalld/pkg:
  pkg.installed:
    - name: {{ firewalld.lookup.pkg }}
    