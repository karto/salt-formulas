
include:
  - www.php-fpm.install
  - www.php-fpm.config
  - www.php-fpm.service



extend:
  www/php-fpm/config/pre:
    test.succeed_without_changes:
      - require:
        - test: www/php-fpm/install
      - watch:
        - test: www/php-fpm/install
  
  www/php-fpm/service:
    service.running:
      - require:
        - test: www/php-fpm/config
      - watch:
        - test: www/php-fpm/config
