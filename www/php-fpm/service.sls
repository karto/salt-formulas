{% from "www/php-fpm/map.jinja" import php_fpm with context %}

www/php-fpm/service:
  service.running:
    - name: {{ php_fpm.lookup.service }}
    - enable: True
    - reload: True
