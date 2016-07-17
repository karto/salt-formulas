{% from "www/uwsgi/map.jinja" import uwsgi with context %}

www/uwsgi/install/pre:
  test.succeed_without_changes:
    - require_in:
      - pkg: www/uwsgi/install/pkg

www/uwsgi/install:
  test.succeed_without_changes:
    - require:
      - pkg: www/uwsgi/install/pkg
    - watch:
      - pkg: www/uwsgi/install/pkg


www/uwsgi/install/pkg:
  pkg.installed:
    - name: {{ uwsgi.lookup.pkg }}


{% if grains['os'] == 'FreeBSD' %}

{% endif %}

