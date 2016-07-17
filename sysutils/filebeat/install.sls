{% from "sysutils/filebeat/map.jinja" import filebeat with context %}

sysutils/filebeat/install/pre:
  test.succeed_without_changes

sysutils/filebeat/install:
  test.succeed_without_changes:
    - require:
      - test: sysutils/filebeat/install/pre
    - watch:
      - test: sysutils/filebeat/install/pre


{% if grains['os'] == 'RedHat' %}
include:
  - sysutils.beats.pkgrepo
{% endif %}

sysutils/filebeat/install/pkg:
  pkg.installed:
    - name: {{ filebeat.lookup.pkg }}
    - require:
      - test: sysutils/filebeat/install/pre
{% if grains['os'] == 'RedHat' %}
      - pkgrepo: sysutils/beats/pkgrepo
{% endif %}
    - require_in:
      - test: sysutils/filebeat/install
    - watch_in:
      - test: sysutils/filebeat/install
    
