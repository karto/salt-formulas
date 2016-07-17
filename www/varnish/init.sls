
include:
  - www.varnish.pkg
  - www.varnish.conf
  - www.varnish.service

extend:
  www/varnish/conf/pre:
    test.succeed_without_changes:
      - require:
        - test: www/varnish/pkg
      - watch:
        - test: www/varnish/pkg
  
  www/varnish/service:
    service.running:
      - require:
        - test: www/varnish/conf
      - watch:
        - test: www/varnish/conf
