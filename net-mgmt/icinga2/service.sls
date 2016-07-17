{% from "net-mgmt/icinga2/map.jinja" import icinga2 with context %}

net-mgmt/icinga2/service:
  service.running:
    - name: {{ icinga2.lookup.service }}
    - enable: True
    - reload: True
