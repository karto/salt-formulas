{% from "textproc/kibana/map.jinja" import kibana with context %}

textproc/kibana/install/pre:
  test.succeed_without_changes

textproc/kibana/install:
  test.succeed_without_changes:
    - require:
      - test: textproc/kibana/install/pre
    - watch:
      - test: textproc/kibana/install/pre


textproc/kibana/install/pkg:
  pkg.installed:
    - name: {{ kibana.lookup.pkg }}
    - require:
      - test: textproc/kibana/install/pre
    - require_in:
      - test: textproc/kibana/install
    - watch_in:
      - test: textproc/kibana/install


{% if grains['os'] == 'FreeBSD' %}

{% endif %}

