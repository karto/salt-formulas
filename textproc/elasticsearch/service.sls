{% from "textproc/elasticsearch/map.jinja" import elasticsearch with context %}

textproc/elasticsearch/service:
  service.running:
    - name: {{ elasticsearch.lookup.service }}
    - enable: True
