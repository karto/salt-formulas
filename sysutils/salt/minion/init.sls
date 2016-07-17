
include:
  - sysutils.salt.minion.install
  - sysutils.salt.minion.config
  - sysutils.salt.minion.service

extend:
  sysutils/salt/minion/config/pre:
    test.succeed_without_changes:
      - require:
        - pkg: sysutils/salt/minion/install
      - watch:
        - pkg: sysutils/salt/minion/install
  
  sysutils/salt/minion/service:
    service.running:
      - require:
        - test: sysutils/salt/minion/config
      - watch:
        - test: sysutils/salt/minion/config
        - pkg: sysutils/salt/minion/install
