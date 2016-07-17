{% from "net-mgmt/icinga2/map.jinja" import icinga2 with context %}

net-mgmt/icinga2/install:
  pkg.installed:
    - name: {{ icinga2.lookup.pkg }}
    