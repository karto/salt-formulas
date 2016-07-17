
include:
  - sysutils.consul.install
  - sysutils.consul.config
  - sysutils.consul.service


extend:
  sysutils/consul/config/pre:
    test.succeed_without_changes:
      - require:
        - test: sysutils/consul/install
      - watch:
        - test: sysutils/consul/install
  
  sysutils/consul/service:
    service.running:
      - require:
        - test: sysutils/consul/config
      - watch:
        - test: sysutils/consul/config
