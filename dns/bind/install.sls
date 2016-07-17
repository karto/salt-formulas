{% from "dns/bind/map.jinja" import bind with context %}

dns/bind/install:
  pkg.installed:
    - name: {{ bind.lookup.pkg }}
