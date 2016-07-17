{% from "net-mgmt/collectd/map.jinja" import collectd with context %}

net-mgmt/collectd/service:
  service.running:
    - name: {{ collectd.lookup.service }}
    - enable: True
