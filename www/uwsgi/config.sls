{% from "www/uwsgi/map.jinja" import uwsgi with context %}
{% import 'statehelper.sls' as statehelper %}

www/uwsgi/config/pre:
  test.succeed_without_changes

www/uwsgi/config:
  test.succeed_without_changes


{% if uwsgi.lookup.rc_conf %}
www/uwsgi/config/rc_conf:
  file.managed:
    - name: /etc/rc.conf.d/uwsgi
    - contents: {{ uwsgi.lookup.rc_conf|yaml_encode }}
    - require:
      - test: www/uwsgi/config/pre
    - require_in:
      - test: www/uwsgi/config
    - watch_in:
      - test: www/uwsgi/config
{% endif %}
