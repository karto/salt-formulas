{% from "www/php-fpm/map.jinja" import php_fpm with context %}


www/php-fpm/install/pre:
  test.succeed_without_changes:
    - require_in:
      - pkg: www/php-fpm/install/pkg

www/php-fpm/install:
  test.succeed_without_changes:
    - require:
      - pkg: www/php-fpm/install/pkg
    - watch:
      - pkg: www/php-fpm/install/pkg


www/php-fpm/install/pkg:
  pkg.installed:
    - name: {{ php_fpm.lookup.pkg }}


{% if grains['os'] == 'RedHat' %}

{% endif %}
