{% from "net/kafka/map.jinja" import kafka with context %}

net/kafka/service/pre:
  test.succeed_without_changes

net/kafka/service:
  test.succeed_without_changes:
    - require:
      - test: net/kafka/service/pre


net/kafka/service/cservice:
  service.running:
    - name: {{ kafka.lookup.service }}
    - enable: True
    - require:
      - test: net/kafka/service/pre
    - watch:
      - test: net/kafka/service/pre
    - require_in:
      - test: net/kafka/service
    - watch_in:
      - test: net/kafka/service
