{% from "databases/carbon/map.jinja" import carbon with context %}

databases/carbon/service/pre:
  test.succeed_without_changes

databases/carbon/service:
  test.succeed_without_changes:
    - require:
      - test: databases/carbon/service/pre


{% if carbon.lookup.cache_service %}
databases/carbon/service/cache_service:
  service.running:
    - name: {{ carbon.lookup.cache_service }}
    - enable: True
    - require:
      - test: databases/carbon/service/pre
    - watch:
      - test: databases/carbon/service/pre
    - require_in:
      - test: databases/carbon/service
    - watch_in:
      - test: databases/carbon/service
{% endif %}

{% if carbon.lookup.aggregator_service %}
databases/carbon/service/aggregator_service:
  service.running:
    - name: {{ carbon.lookup.aggregator_service }}
    - enable: True
    - require:
      - test: databases/carbon/service/pre
    - watch:
      - test: databases/carbon/service/pre
    - require_in:
      - test: databases/carbon/service
    - watch_in:
      - test: databases/carbon/service
{% endif %}

{% if carbon.lookup.relay_service %}
databases/carbon/service/relay_service:
  service.running:
    - name: {{ carbon.lookup.relay_service }}
    - enable: True
    - require:
      - test: databases/carbon/service/pre
    - watch:
      - test: databases/carbon/service/pre
    - require_in:
      - test: databases/carbon/service
    - watch_in:
      - test: databases/carbon/service
{% endif %}


