{% from "databases/carbon/map.jinja" import carbon with context %}
{% import 'statehelper.sls' as statehelper %}

databases/carbon/config/pre:
  test.succeed_without_changes
#    - require_in:
#      - file: databases/carbon/config/file

databases/carbon/config:
  test.succeed_without_changes
#    - require:
#      - file: databases/carbon/config/file
#    - watch:
#      - file: databases/carbon/config/file

{% for file in ['aggregation-rules.conf', 'carbon.conf', 'storage-aggregation.conf', 'blacklist.conf', 'relay-rules.conf', 'storage-schemas.conf', 'carbon.amqp.conf', 'rewrite-rules.conf', 'whitelist.conf'] %}
databases/carbon/config/dir/{{ file }}:
  file.managed:
    - name: {{ carbon.lookup.config_dir }}/{{ file }}
    - source:
        {{ statehelper.statesource("databases/carbon", file)|indent(6) }}
    - template: jinja
    - defaults:
        carbon: {{ carbon }}
    - require:
      - test: databases/carbon/config/pre
    - require_in:
      - test: databases/carbon/config
    - watch_in:
      - test: databases/carbon/config
{% endfor %}


{% if carbon.lookup.cache_rc_conf %}
databases/carbon/config/cache_rc_conf:
  file.managed:
    - name: /etc/rc.conf.d/carbon_cache
    - contents: {{ carbon.lookup.cache_rc_conf }}
    - require:
      - test: databases/carbon/config/pre
    - require_in:
      - test: databases/carbon/config
    - watch_in:
      - test: databases/carbon/config
{% endif %}

{% if carbon.lookup.relay_rc_conf %}
databases/carbon/config/relay_rc_conf:
  file.managed:
    - name: /etc/rc.conf.d/carbon_relay
    - contents: {{ carbon.lookup.relay_rc_conf }}
    - require:
      - test: databases/carbon/config/pre
    - require_in:
      - test: databases/carbon/config
    - watch_in:
      - test: databases/carbon/config
{% endif %}

{% if carbon.lookup.aggregator_rc_conf %}
databases/carbon/config/aggregator_rc_conf:
  file.managed:
    - name: /etc/rc.conf.d/carbon_aggregator
    - contents: {{ carbon.lookup.aggregator_rc_conf }}
    - require:
      - test: databases/carbon/config/pre
    - require_in:
      - test: databases/carbon/config
    - watch_in:
      - test: databases/carbon/config
{% endif %}

