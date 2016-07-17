
include:
  - net-mgmt.collectd.install
  - net-mgmt.collectd.config
  - net-mgmt.collectd.service

extend:
  net-mgmt/collectd/config/pre:
    test.succeed_without_changes:
      - require:
        - test: net-mgmt/collectd/install
      - watch:
        - test: net-mgmt/collectd/install
  
  net-mgmt/collectd/service:
    service.running:
      - require:
        - test: net-mgmt/collectd/config
      - watch:
        - test: net-mgmt/collectd/config
