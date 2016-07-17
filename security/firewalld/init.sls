
include:
  - security.firewalld.pkg
  - security.firewalld.conf
  - security.firewalld.service

extend:
  security/firewalld/conf/pre:
    test.succeed_without_changes:
      - require:
        - pkg: security/firewalld/pkg
      - watch:
        - pkg: security/firewalld/pkg
  
  security/firewalld/service:
    service.running:
      - require:
        - test: security/firewalld/conf
      - watch:
        - test: security/firewalld/conf
        - pkg: security/firewalld/pkg
