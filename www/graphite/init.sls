
include:
  - www.graphite.install
  - www.graphite.config


extend:
  www/graphite/config/pre:
    test.succeed_without_changes:
      - require:
        - test: www/graphite/install
      - watch:
        - test: www/graphite/install
  