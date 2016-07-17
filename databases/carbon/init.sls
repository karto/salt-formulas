
include:
  - databases.carbon.install
  - databases.carbon.config
  - databases.carbon.service


extend:
  databases/carbon/config/pre:
    test.succeed_without_changes:
      - require:
        - test: databases/carbon/install
      - watch:
        - test: databases/carbon/install
  
  databases/carbon/service/pre:
    test.succeed_without_changes:
      - require:
        - test: databases/carbon/config
      - watch:
        - test: databases/carbon/config
