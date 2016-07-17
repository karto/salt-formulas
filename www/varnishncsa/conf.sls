{% from "varnishncsa/map.jinja" import varnishncsa with context %}

{% if grains['os_family'] == 'RedHat' %}

varnishncsa/conf/sysconfig:
  file.managed:
    - name: /etc/sysconfig/varnishncsa
    - source:
        {% for environment in pillar.get('environments', []) %}
        {% for cluster in pillar.get('clusters', []) %}
        - salt://{{ environment }}/varnishncsa/{{ cluster }}/sysconfig
        {% endfor %}
        - salt://{{ environment }}/varnishncsa/sysconfig
        {% endfor %}
        - salt://varnishncsa/files/sysconfig
    - template: jinja
    - defaults:
        varnishncsa: {{ varnishncsa }}

{% endif %}
