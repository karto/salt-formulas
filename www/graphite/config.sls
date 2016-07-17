{% from "www/graphite/map.jinja" import graphite with context %}
{% import 'statehelper.sls' as statehelper %}

www/graphite/config/pre:
  test.succeed_without_changes

www/graphite/config:
  test.succeed_without_changes:
    - require:
      - test: www/graphite/config/pre
    - watch:
      - test: www/graphite/config/pre


{% for file in ['dashboard.conf','graphTemplates.conf','graphite.wsgi','local_settings.py'] %}
www/graphite/config/dir/{{ file }}:
  file.managed:
    - name: {{ graphite.lookup.config_dir }}/{{ file }}
    - source:
        {{ statehelper.statesource("www/graphite", file)|indent(6) }}
    - template: jinja
    - defaults:
        graphite: {{ graphite }}
    - require:
      - test: www/graphite/config/pre
    - require_in:
      - test: www/graphite/config
    - watch_in:
      - test: www/graphite/config
{% endfor %}
