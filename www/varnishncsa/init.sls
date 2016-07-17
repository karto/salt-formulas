{% from "varnishncsa/map.jinja" import varnishncsa with context %}

include:
  - varnishncsa.conf

varnishncsa:
  service.running:
    - name: {{ varnishncsa.lookup.service }}
    - enable: True
{% if grains['os_family'] == 'RedHat' %}
    - require:
      - file: varnishncsa/sysconfig
      - file: drweblog/fifo
    - watch:
      - file: varnishncsa/sysconfig
{% endif %}
