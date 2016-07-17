
include:
  - sysutils.salt.master.install
  - sysutils.salt.master.config
  - sysutils.salt.master.service


extend:
  sysutils/salt/master/config/pre:
    test.succeed_without_changes:
      - require:
        - test: sysutils/salt/master/install
      - watch:
        - test: sysutils/salt/master/install
  
  sysutils/salt/master/service/pre:
    test.succeed_without_changes:
      - require:
        - test: sysutils/salt/master/config
      - watch:
        - test: sysutils/salt/master/config
