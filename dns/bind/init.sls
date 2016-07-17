
include:
  - dns.bind.install
  - dns.bind.config
  - dns.bind.service


extend:
  dns/bind/config/pre:
    test.succeed_without_changes:
      - require:
        - pkg: dns/bind/install
      - watch:
        - pkg: dns/bind/install
  
  dns/bind/service:
    service.running:
      - require:
        - test: dns/bind/config
      - watch:
        - test: dns/bind/config
