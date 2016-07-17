{% from "devel/zookeeper/map.jinja" import zookeeper with context %}

devel/zookeeper/install/pre:
  test.succeed_without_changes:
    - require_in:
      - pkg: devel/zookeeper/install/pkg

devel/zookeeper/install:
  test.succeed_without_changes:
    - require:
      - test: devel/zookeeper/install/pre
      - pkg: devel/zookeeper/install/pkg
    - watch:
      - test: devel/zookeeper/install/pre
      - pkg: devel/zookeeper/install/pkg


devel/zookeeper/install/pkg:
  pkg.installed:
    - name: {{ zookeeper.lookup.pkg }}

{% if grains['os'] == 'FreeBSD' %}
{% endif %}
