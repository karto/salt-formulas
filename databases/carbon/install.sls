{% from "databases/carbon/map.jinja" import carbon with context %}

databases/carbon/install/pre:
  test.succeed_without_changes:
    - require_in:
      - pkg: databases/carbon/install/pkg
      - user: databases/carbon/install/user
{% if grains['os'] == 'FreeBSD' %}
      - file: databases/carbon/install/rc.d/carbon-cache
      - file: databases/carbon/install/rc.d/carbon-relay
      - file: databases/carbon/install/rc.d/carbon-aggregator
{% endif %}

databases/carbon/install:
  test.succeed_without_changes:
    - require:
      - pkg: databases/carbon/install/pkg
      - user: databases/carbon/install/user
{% if grains['os'] == 'FreeBSD' %}
      - file: databases/carbon/install/rc.d/carbon-cache
      - file: databases/carbon/install/rc.d/carbon-relay
      - file: databases/carbon/install/rc.d/carbon-aggregator
{% endif %}
    - watch:
      - pkg: databases/carbon/install/pkg
      - user: databases/carbon/install/user
{% if grains['os'] == 'FreeBSD' %}
      - file: databases/carbon/install/rc.d/carbon-cache
      - file: databases/carbon/install/rc.d/carbon-relay
      - file: databases/carbon/install/rc.d/carbon-aggregator
{% endif %}


databases/carbon/install/pkg:
  pkg.installed:
    - name: {{ carbon.lookup.pkg }}

databases/carbon/install/user:
  user.present:
    - name: carbon
    - fullname: Graphite Carbon services
    - system: True


{% if grains['os'] == 'FreeBSD' %}

databases/carbon/install/rc.d/carbon-cache:
  file.managed:
    - name: /usr/local/etc/rc.d/carbon-cache
    - source: salt://databases/carbon/files/FreeBSD/carbon-cache
    - mode: 0555

databases/carbon/install/rc.d/carbon-relay:
  file.managed:
    - name: /usr/local/etc/rc.d/carbon-relay
    - source: salt://databases/carbon/files/FreeBSD/carbon-relay
    - mode: 0555

databases/carbon/install/rc.d/carbon-aggregator:
  file.managed:
    - name: /usr/local/etc/rc.d/carbon-aggregator
    - source: salt://databases/carbon/files/FreeBSD/carbon-aggregator
    - mode: 0555

{% endif %}
