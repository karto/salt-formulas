{% from "www/grafana/map.jinja" import grafana with context %}

www/grafana/install/pre:
  test.succeed_without_changes

www/grafana/install:
  test.succeed_without_changes:
    - require:
      - test: www/grafana/install/pre
    - watch:
      - test: www/grafana/install/pre


www/grafana/install/pkg:
  pkg.installed:
    - name: {{ grafana.lookup.pkg }}
    - require:
      - test: www/grafana/install/pre
    - require_in:
      - test: www/grafana/install
    - watch_in:
      - test: www/grafana/install


{% if grains['os'] == 'FreeBSD' %}

{% endif %}

