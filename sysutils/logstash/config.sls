{% from "sysutils/logstash/map.jinja" import logstash with context %}
{% import 'statehelper.sls' as statehelper %}

sysutils/logstash/config/pre:
  test.succeed_without_changes:
    - require:
      - file: sysutils/logstash/config/conf.d
      - file: sysutils/logstash/config/patterns
      - file: sysutils/logstash/config/elasticsearch_templates

sysutils/logstash/config:
  test.succeed_without_changes:
    - require:
      - test: sysutils/logstash/config/pre
      - file: sysutils/logstash/config/conf.d
      - file: sysutils/logstash/config/patterns
      - file: sysutils/logstash/config/elasticsearch_templates
    - watch:
      - test: sysutils/logstash/config/pre
      - file: sysutils/logstash/config/conf.d
      - file: sysutils/logstash/config/patterns
      - file: sysutils/logstash/config/elasticsearch_templates


sysutils/logstash/config/conf.d:
  file.recurse:
    - name: {{ logstash.lookup.config_dir }}
    - source:
        {{ statehelper.statesource("sysutils/logstash", "conf.d")|indent(6) }}
    - clean: true
    - exclude_pat: "E@(^|/)\\._|\\.sample$"
    - template: jinja
    - defaults:
        logstash: {{ logstash }}

sysutils/logstash/config/patterns:
  file.recurse:
    - name: {{ logstash.lookup.patterns_dir }}
    - source:
        {{ statehelper.statesource("sysutils/logstash", "patterns")|indent(6) }}
    - clean: true
    - exclude_pat: "E@(^|/)\\._|\\.sample$"
    - template: jinja
    - defaults:
        logstash: {{ logstash }}

sysutils/logstash/config/elasticsearch_templates:
  file.recurse:
    - name: {{ logstash.lookup.elasticsearch_templates_dir }}
    - source:
        {{ statehelper.statesource("sysutils/logstash", "elasticsearch_templates")|indent(6) }}
    - clean: true
    - exclude_pat: "E@(^|/)\\._|\\.sample$"
    - template: jinja
    - defaults:
        logstash: {{ logstash }}


{% if grains['os'] == 'FreeBSD' %}
sysutils/logstash/config/rc_conf:
{% if logstash.lookup.rc_conf %}
  file.managed:
    - name: /etc/rc.conf.d/logstash
    - contents: {{ logstash.lookup.rc_conf|yaml_encode }}
{% else %}
  file.absent:
    - name: /etc/rc.conf.d/logstash
{% endif %}
    - require:
      - test: sysutils/logstash/config/pre
    - require_in:
      - test: sysutils/logstash/config
    - watch_in:
      - test: sysutils/logstash/config
{% endif %}
