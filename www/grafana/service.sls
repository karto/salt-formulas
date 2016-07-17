{% from "www/grafana/map.jinja" import grafana with context %}

www/grafana/service/pre:
  test.succeed_without_changes

www/grafana/service:
  test.succeed_without_changes:
    - require:
      - test: www/grafana/service/pre
    - watch:
      - test: www/grafana/service/pre


www/grafana/service/running:
  service.running:
    - name: {{ grafana.lookup.service }}
    - enable: True
    - require:
      - test: www/grafana/service/pre
    - require_in:
      - test: www/grafana/service
    - watch_in:
      - test: www/grafana/service

