
include:
  - net.natd.config
  - net.natd.service


extend:
  net/natd/service/pre:
    test.succeed_without_changes:
      - require:
        - test: net/natd/config
      - watch:
        - test: net/natd/config
