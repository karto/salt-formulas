{% from "textproc/kibana/map.jinja" import kibana with context %}

textproc/kibana/service/pre:
  test.succeed_without_changes

textproc/kibana/service:
  test.succeed_without_changes:
    - require:
      - test: textproc/kibana/service/pre
    - watch:
      - test: textproc/kibana/service/pre


textproc/kibana/service/running:
  service.running:
    - name: {{ kibana.lookup.service }}
    - enable: True
    - require:
      - test: textproc/kibana/service/pre
    - require_in:
      - test: textproc/kibana/service
    - watch_in:
      - test: textproc/kibana/service

