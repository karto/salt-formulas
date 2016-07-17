
include:
  - databases.postgresql.install
  - databases.postgresql.config
  - databases.postgresql.service


extend:
  databases/postgresql/config/pre:
    test.succeed_without_changes:
      - require:
        - test: databases/postgresql/install
      - watch:
        - test: databases/postgresql/install
  
  databases/postgresql/service:
    service.running:
      - require:
        - test: databases/postgresql/config
      - watch:
        - test: databases/postgresql/config
