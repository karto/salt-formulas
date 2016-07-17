{% from "lang/php/map.jinja" import php with context %}
{% import 'statehelper.sls' as statehelper %}


lang/php/config/pre:
  test.succeed_without_changes:
    - require_in:
      - file: lang/php/config/file
{% if grains['os'] == 'FreeBSD' %}
{% endif %}

lang/php/config:
  test.succeed_without_changes:
    - require:
      - file: lang/php/config/file
{% if grains['os'] == 'FreeBSD' %}
{% endif %}
    - watch:
      - file: lang/php/config/file
{% if grains['os'] == 'FreeBSD' %}
{% endif %}


lang/php/config/file:
  file.managed:
    - name: {{ php.lookup.config_file }}
    - source:
        {{ statehelper.statesource("lang/php", "php.ini")|indent(6) }}
    - template: jinja
    - defaults:
        php: {{ php }}

{% if grains['os'] == 'FreeBSD' %}

{% endif %}
