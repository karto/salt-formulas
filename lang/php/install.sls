{% from "lang/php/map.jinja" import php with context %}


lang/php/install/pre:
  test.succeed_without_changes:
    - require_in:
      - pkg: lang/php/install/pkg

lang/php/install:
  test.succeed_without_changes:
    - require:
      - pkg: lang/php/install/pkg
    - watch:
      - pkg: lang/php/install/pkg


lang/php/install/pkg:
  pkg.installed:
    - name: {{ php.lookup.pkg }}


{% if grains['os'] == 'RedHat' %}

{% endif %}
