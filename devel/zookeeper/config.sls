{% from "devel/zookeeper/map.jinja" import zookeeper with context %}
{% import 'statehelper.sls' as statehelper %}

devel/zookeeper/config/pre:
  test.succeed_without_changes

devel/zookeeper/config:
  test.succeed_without_changes:
    - require:
      - test: devel/zookeeper/config/pre
    - watch:
      - test: devel/zookeeper/config/pre

devel/zookeeper/config/file:
  file.managed:
    - name: {{ zookeeper.lookup.config_file }}
    - source:
        {{ statehelper.statesource("devel/zookeeper", 'zoo.cfg')|indent(6) }}
    - template: jinja
    - defaults:
        zookeeper: {{ zookeeper }}
    - require:
      - test: devel/zookeeper/config/pre
    - require_in:
      - test: devel/zookeeper/config
    - watch_in:
      - test: devel/zookeeper/config

{% if zookeeper.myid %}
devel/zookeeper/config/myid:
  file.managed:
    - name: {{ zookeeper.lookup.myid_file }}
    - contents: {{ zookeeper.myid }}
    - require:
      - test: devel/zookeeper/config/pre
    - require_in:
      - test: devel/zookeeper/config
    - watch_in:
      - test: devel/zookeeper/config
{% endif %}
