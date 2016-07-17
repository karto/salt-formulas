
include:
  - databases.pgpoolii.install
  - databases.pgpoolii.config
  - databases.pgpoolii.service


extend:
  databases/pgpoolii/config/pre:
    test.succeed_without_changes:
      - require:
        - test: databases/pgpoolii/install
      - watch:
        - test: databases/pgpoolii/install
  
  databases/pgpoolii/service:
    service.running:
      - require:
        - test: databases/pgpoolii/config
      - watch:
        - test: databases/pgpoolii/config
