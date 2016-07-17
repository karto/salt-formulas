{% from "www/grafana/map.jinja" import grafana with context %}
{% import 'statehelper.sls' as statehelper %}

www/grafana/config/pre:
  test.succeed_without_changes

www/grafana/config:
  test.succeed_without_changes:
    - require:
      - test: www/grafana/config/pre
    - watch:
      - test: www/grafana/config/pre

www/grafana/config/file:
  file.managed:
    - name: {{ grafana.lookup.config_file }}
    - source:
        {{ statehelper.statesource("www/grafana", "grafana3.conf")|indent(6) }}
    - template: jinja
    - defaults:
        grafana: {{ grafana }}
    - require:
      - test: www/grafana/config/pre
    - require_in:
      - test: www/grafana/config
    - watch_in:
      - test: www/grafana/config

{% if grafana.lookup.rc_conf %}
www/grafana/config/rc_conf:
  file.managed:
    - name: /etc/rc.conf.d/grafana3
    - contents: {{ grafana.lookup.rc_conf|yaml_encode }}
    - require:
      - test: www/grafana/config/pre
    - require_in:
      - test: www/grafana/config
    - watch_in:
      - test: www/grafana/config
{% endif %}
