{% from "www/uwsgi/map.jinja" import uwsgi with context %}

www/uwsgi/service/pre:
  test.succeed_without_changes:
    - require_in:
      - service: www/uwsgi/service/service
    - watch_in:
      - service: www/uwsgi/service/service

www/uwsgi/service:
  test.succeed_without_changes:
    - require:
      - test: www/uwsgi/service/pre
      - service: www/uwsgi/service/service
    - watch:
      - test: www/uwsgi/service/pre
      - service: www/uwsgi/service/service

www/uwsgi/service/service:
  service.running:
    - name: {{ uwsgi.lookup.service }}
    - enable: True

