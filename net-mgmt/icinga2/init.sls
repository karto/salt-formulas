include:
  - net-mgmt.icinga2.install
  - net-mgmt.icinga2.config
  - net-mgmt.icinga2.service

extend:
  net-mgmt/icinga2/config/pre:
    test.succeed_without_changes:
      - require:
        - pkg: net-mgmt/icinga2/install
      - watch:
        - pkg: net-mgmt/icinga2/install
  
  net-mgmt/icinga2/service:
    service.running:
      - require:
        - test: net-mgmt/icinga2/config
      - watch:
        - test: net-mgmt/icinga2/config
