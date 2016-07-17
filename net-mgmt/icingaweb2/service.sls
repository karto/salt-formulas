{% from "net-mgmt/icingaweb2/map.jinja" import icingaweb2 with context %}

net-mgmt/icingaweb2/service:
  service.running:
    - name: {{ icingaweb2.lookup.service }}
    - enable: True
