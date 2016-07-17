
include:
  - net-mgmt.icingaweb2.install
  - net-mgmt.icingaweb2.config
  - net-mgmt.icingaweb2.service


extend:
  net-mgmt/icingaweb2/config/pre:
    test.succeed_without_changes:
      - require:
        - test: net-mgmt/icingaweb2/install
      - watch:
        - test: net-mgmt/icingaweb2/install
  
  net-mgmt/icingaweb2/service:
    service.running:
      - require:
        - test: net-mgmt/icingaweb2/config
      - watch:
        - test: net-mgmt/icingaweb2/config
