{% from "www/nginx/map.jinja" import nginx with context %}

www/nginx/service/pre:
  test.succeed_without_changes

www/nginx/service:
  test.succeed_without_changes:
    - require:
      - test: www/nginx/service/pre
    - watch:
      - test: www/nginx/service/pre

www/nginx/service/service:
  service.running:
    - name: {{ nginx.lookup.service }}
    - enable: True
    - reload: True
    - require:
      - test: www/nginx/service/pre
    - watch:
      - test: www/nginx/service/pre
    - require_in:
      - test: www/nginx/service
    - watch_in:
      - test: www/nginx/service
    

