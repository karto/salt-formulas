
include:
  - textproc.elasticsearch.install
  - textproc.elasticsearch.config
  - textproc.elasticsearch.plugin
  - textproc.elasticsearch.service

extend:
  textproc/elasticsearch/config/pre:
    test.succeed_without_changes:
      - require:
        - pkg: textproc/elasticsearch/pkg
      - watch:
        - pkg: textproc/elasticsearch/pkg
  
  textproc/elasticsearch/plugin/pre:
    test.succeed_without_changes:
      - require:
        - test: textproc/elasticsearch/config
      - watch:
        - test: textproc/elasticsearch/config
  
  textproc/elasticsearch/service:
    service.running:
      - require:
        - test: textproc/elasticsearch/config
        - test: textproc/elasticsearch/plugin
      - watch:
        - test: textproc/elasticsearch/config
        - test: textproc/elasticsearch/plugin


