{% from "textproc/elasticsearch/map.jinja" import elasticsearch with context %}
{% import 'statehelper.sls' as statehelper %}


textproc/elasticsearch/config/pre:
  test.succeed_without_changes:
    - require_in:
      - file: textproc/elasticsearch/config/file
#      - file: textproc/elasticsearch/config/maintaince_script

textproc/elasticsearch/config:
  test.succeed_without_changes:
    - require:
      - file: textproc/elasticsearch/config/file
#      - file: textproc/elasticsearch/config/maintaince_script
    - watch:
      - file: textproc/elasticsearch/config/file
#      - file: textproc/elasticsearch/config/maintaince_script


textproc/elasticsearch/config/file:
  file.managed:
    - name: {{ elasticsearch.lookup.config }}
    - source:
        {{ statehelper.statesource("textproc/elasticsearch", 'elasticsearch.yml')|indent(6) }}
    - template: jinja
    - defaults:
        elasticsearch: {{ elasticsearch }}

{#
textproc/elasticsearch/config/maintaince_script:
  file.managed:
    - name: {{ elasticsearch.lookup.maintaince_script }}
    - source:
        {{ statehelper.statesource("textproc/elasticsearch", 'maintaince.sh')|indent(6) }}
    - mode: 0755
    - template: jinja
    - defaults:
        elasticsearch: {{ elasticsearch }}
#}

{% if elasticsearch.lookup.rc_conf %}
textproc/elasticsearch/config/rc_conf:
  file.managed:
    - name: /etc/rc.conf.d/elasticsearch
    - contents: {{ elasticsearch.lookup.rc_conf|yaml_encode }}
    - require:
      - test: textproc/elasticsearch/config/pre
    - require_in:
      - test: textproc/elasticsearch/config
    - watch_in:
      - test: textproc/elasticsearch/config
{% endif %}

