
include:
  - security.pf.config
  - security.pf.service


extend:
  security/pf/service/pre:
    test.succeed_without_changes:
      - require:
        - test: security/pf/config
      - watch:
        - test: security/pf/config
