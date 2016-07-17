{% from "sysutils/logstash/map.jinja" import logstash with context %}

sysutils/logstash/install/pre:
  test.succeed_without_changes:
    - require:
      - pkg: sysutils/logstash/install/pkg
{% if grains['os'] == 'FreeBSD' %}
      - user: sysutils/logstash/install/user
      - file: sysutils/logstash/install/user/home
      - file: sysutils/logstash/install/user/run
      - file: sysutils/logstash/install/user/db
      - file: sysutils/logstash/install/user/log
{% endif %}

sysutils/logstash/install:
  test.succeed_without_changes:
    - require:
      - test: sysutils/logstash/install/pre
      - pkg: sysutils/logstash/install/pkg
{% if grains['os'] == 'FreeBSD' %}
      - user: sysutils/logstash/install/user
      - file: sysutils/logstash/install/user/home
      - file: sysutils/logstash/install/user/run
      - file: sysutils/logstash/install/user/db
      - file: sysutils/logstash/install/user/log
{% endif %}
    - watch:
      - test: sysutils/logstash/install/pre
      - pkg: sysutils/logstash/install/pkg
{% if grains['os'] == 'FreeBSD' %}
      - user: sysutils/logstash/install/user
      - file: sysutils/logstash/install/user/home
      - file: sysutils/logstash/install/user/run
      - file: sysutils/logstash/install/user/db
      - file: sysutils/logstash/install/user/log
{% endif %}


sysutils/logstash/install/pkg:
  pkg.installed:
    - name: {{ logstash.lookup.pkg }}


{% if grains['os'] == 'FreeBSD' %}

sysutils/logstash/install/user:
  user.present:
    - name: logstash
    - gid_from_name: true
    - groups:
      - daemon
    - home: /usr/local/logstash
    - createhome: false
    - shell: /bin/sh
#/usr/sbin/nologin
    - system: true
    - fullname: Logstash daemon

sysutils/logstash/install/user/home:
  file.directory:
    - name: /usr/local/logstash
    - user: logstash
    - group: logstash

sysutils/logstash/install/user/run:
  file.directory:
    - name: /var/run/logstash
    - user: logstash
    - group: logstash

sysutils/logstash/install/user/db:
  file.directory:
    - name: /var/db/logstash
    - user: logstash
    - group: logstash

sysutils/logstash/install/user/log:
  file.managed:
    - name: /var/log/logstash.log
    - replace: false
    - user: logstash
    - group: logstash

{% endif %}
