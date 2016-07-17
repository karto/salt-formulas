{% from "www/varnish/map.jinja" import varnish with context %}
{% import 'statehelper.sls' as statehelper %}

include:
  - www.varnish.vcl

www/varnish/conf/pre:
  test.succeed_without_changes:
    - require_in:
      - test: www/varnish/vcl/pre


www/varnish/conf:
  test.succeed_without_changes:
    - require:
      - test: www/varnish/vcl
    - watch:
      - test: www/varnish/vcl


{% if grains['os'] == 'RedHat' %}
{% if grains['osmajorrelease'] == '6' %}
www/varnish/conf/sysconfig:
  file.managed:
    - name: /etc/sysconfig/varnish
    - source:
        {{ statehelper.statesource("www/varnish", "sysconfig")|indent(6) }}
    - template: jinja
    - defaults:
        varnish: {{ varnish }}
    - require:
      - test: www/varnish/conf/pre
    - require_in:
      - test: www/varnish/conf
    - watch_in:
      - test: www/varnish/conf
{% endif %}
{% if grains['osmajorrelease'] == '7' %}
www/varnish/conf/varnish.params:
  file.managed:
    - name: /etc/varnish/varnish.params
    - source:
        {{ statehelper.statesource("www/varnish", "varnish.params")|indent(6) }}
    - template: jinja
    - defaults:
        varnish: {{ varnish }}
    - require:
      - test: www/varnish/conf/pre
      - test: www/varnish/vcl
    - watch:
      - test: www/varnish/conf/pre
      - test: www/varnish/vcl
    - require_in:
      - test: www/varnish/conf
    - watch_in:
      - test: www/varnish/conf
{% endif %}
{% endif %}
