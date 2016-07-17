{% from "www/php-fpm/map.jinja" import php_fpm with context %}
{% import 'statehelper.sls' as statehelper %}


www/php-fpm/config/pre:
  test.succeed_without_changes:
    - require_in:
      - file: www/php-fpm/config/file
{#      - file: www/php-fpm/config/dir#}
{% if grains['os'] == 'FreeBSD' %}
{% endif %}

www/php-fpm/config:
  test.succeed_without_changes:
    - require:
      - file: www/php-fpm/config/file
{#      - file: www/php-fpm/config/dir#}
{% if grains['os'] == 'FreeBSD' %}
{% endif %}
    - watch:
      - file: www/php-fpm/config/file
{#      - file: www/php-fpm/config/dir#}
{% if grains['os'] == 'FreeBSD' %}
{% endif %}


www/php-fpm/config/file:
  file.managed:
    - name: {{ php_fpm.lookup.config_file }}
    - source:
        {{ statehelper.statesource("www/php-fpm", "php-fpm.conf")|indent(6) }}
    - template: jinja
    - defaults:
        php_fpm: {{ php_fpm }}
{#
www/php-fpm/config/dir:
  file.recurse:
    - name: {{ php_fpm.lookup.config_dir }}
    - source:
        {{ statehelper.statesource("www/php-fpm", "fpm.d")|indent(6) }}
    - clean: true
    - exclude_pat: "E@(^|/)\\._|\\.sample$"
    - makedirs: true
    - template: jinja
    - defaults:
        php_fpm: {{ php_fpm }}
#}
{% if grains['os'] == 'FreeBSD' %}

{% endif %}
