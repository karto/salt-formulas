{% from "textproc/elasticsearch/map.jinja" import elasticsearch with context %}

textproc/elasticsearch/pkg:
  pkg.installed:
    - name: {{ elasticsearch.lookup.pkg }}
