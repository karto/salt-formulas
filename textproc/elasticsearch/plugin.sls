{% from "textproc/elasticsearch/map.jinja" import elasticsearch with context %}



textproc/elasticsearch/plugin/pre:
  test:
    - succeed_without_changes

textproc/elasticsearch/plugin:
  test.succeed_without_changes:
    - require:
      - test: textproc/elasticsearch/plugin/pre


{% for plugin, name in elasticsearch.plugins.iteritems() %}

textproc/elasticsearch/plugin/{{ plugin }}:
  cmd.run:
    - name: elasticsearch-plugin install {{ name }}
    - unless: elasticsearch-plugin list | grep -i {{ plugin }}
    - require:
      - test: textproc/elasticsearch/plugin/pre
    - require_in:
      - test: textproc/elasticsearch/plugin
    - watche_in:
      - test: textproc/elasticsearch/plugin

{% endfor %}

