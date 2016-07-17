
include:
  - www.nginx.install
  - www.nginx.config
  - www.nginx.service



extend:
  www/nginx/config/pre:
    test.succeed_without_changes:
      - require:
        - test: www/nginx/install
      - watch:
        - test: www/nginx/install
  
  www/nginx/service/pre:
    test.succeed_without_changes:
      - require:
        - test: www/nginx/config
      - watch:
        - test: www/nginx/config
