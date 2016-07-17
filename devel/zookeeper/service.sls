{% from "devel/zookeeper/map.jinja" import zookeeper with context %}

devel/zookeeper/service/pre:
  test.succeed_without_changes

devel/zookeeper/service:
  test.succeed_without_changes:
    - require:
      - test: devel/zookeeper/service/pre
    - watch:
      - test: devel/zookeeper/service/pre


devel/zookeeper/service/service:
  service.running:
    - name: {{ zookeeper.lookup.service }}
    - enable: True
    - require:
      - test: devel/zookeeper/service/pre
    - watch:
      - test: devel/zookeeper/service/pre
    - require_in:
      - test: devel/zookeeper/service
    - watch_in:
      - test: devel/zookeeper/service

