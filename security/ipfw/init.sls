
include:
  - security.ipfw.config
  - security.ipfw.service


extend:
  security/ipfw/service/pre:
    test.succeed_without_changes:
      - require:
        - test: security/ipfw/config
      - watch:
        - test: security/ipfw/config
