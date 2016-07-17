{% from "net/kafka/map.jinja" import kafka with context %}
{% import 'statehelper.sls' as statehelper %}

net/kafka/config/pre:
  test.succeed_without_changes:
    - require_in:
      - file: net/kafka/config/file
      - file: net/kafka/config/log4j

net/kafka/config:
  test.succeed_without_changes:
    - require:
      - test: net/kafka/config/pre
      - file: net/kafka/config/file
      - file: net/kafka/config/log4j
    - watch:
      - test: net/kafka/config/pre
      - file: net/kafka/config/file
      - file: net/kafka/config/log4j


net/kafka/config/file:
  file.managed:
    - name: {{ kafka.lookup.config_file }}
    - source:
        {{ statehelper.statesource("net/kafka", 'server.properties')|indent(6) }}
    - template: jinja
    - defaults:
        kafka: {{ kafka }}

net/kafka/config/log4j:
  file.managed:
    - name: {{ kafka.lookup.log4j_file }}
    - source:
        {{ statehelper.statesource("net/kafka", 'log4j.properties')|indent(6) }}
    - template: jinja
    - defaults:
        kafka: {{ kafka }}

{% if kafka.lookup.rc_conf %}
net/kafka/config/rc_conf:
  file.managed:
    - name: /etc/rc.conf.d/kafka
    - contents: {{ kafka.lookup.rc_conf }}
    - require:
      - test: net/kafka/config/pre
    - require_in:
      - test: net/kafka/config
    - watch_in:
      - test: net/kafka/config
{% endif %}

