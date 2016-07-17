
include:
  - security.vault.install
  - security.vault.config
  - security.vault.service


extend:
  security/vault/config/pre:
    test.succeed_without_changes:
      - require:
        - test: security/vault/install
      - watch:
        - test: security/vault/install
  
  security/vault/service:
    service.running:
      - require:
        - test: security/vault/config
      - watch:
        - test: security/vault/config
