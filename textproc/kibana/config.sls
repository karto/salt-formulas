{% from "textproc/kibana/map.jinja" import kibana with context %}
{% import 'statehelper.sls' as statehelper %}

textproc/kibana/config/pre:
  test.succeed_without_changes

textproc/kibana/config:
  test.succeed_without_changes:
    - require:
      - test: textproc/kibana/config/pre
    - watch:
      - test: textproc/kibana/config/pre

textproc/kibana/config/file:
  file.managed:
    - name: {{ kibana.lookup.config_file }}
    - source:
        {{ statehelper.statesource("textproc/kibana", "kibana.yml")|indent(6) }}
    - template: jinja
    - defaults:
        kibana: {{ kibana }}
    - require:
      - test: textproc/kibana/config/pre
    - require_in:
      - test: textproc/kibana/config
    - watch_in:
      - test: textproc/kibana/config

{% if kibana.lookup.rc_conf %}
textproc/kibana/config/rc_conf:
  file.managed:
    - name: /etc/rc.conf.d/kibana
    - contents: {{ kibana.lookup.rc_conf|yaml_encode }}
    - require:
      - test: textproc/kibana/config/pre
    - require_in:
      - test: textproc/kibana/config
    - watch_in:
      - test: textproc/kibana/config
{% endif %}
