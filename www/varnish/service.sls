{% from "www/varnish/map.jinja" import varnish with context %}

www/varnish/service:
  service.running:
    - name: {{ varnish.lookup.service }}
    - enable: True
    - reload: True
