{% from "net/kafka/map.jinja" import kafka with context %}

net/kafka/install/pre:
  test.succeed_without_changes

net/kafka/install:
  test.succeed_without_changes:
    - require:
      - test: net/kafka/install/pre
    - watch:
      - test: net/kafka/install/pre

{% if kafka.lookup.pkg %}
net/kafka/install/pkg:
  pkg.installed:
    - name: {{ kafka.lookup.pkg }}
    - require:
      - test: net/kafka/install/pre
    - require_in:
      - test: net/kafka/install
    - watch_in:
      - test: net/kafka/install
{% endif %}

{% if kafka.lookup.extra_pkgs %}
net/kafka/install/extra_pkgs:
  pkg.installed:
    - pkgs: {{ kafka.lookup.extra_pkgs }}
    - require:
      - test: net/kafka/install/pre
    - require_in:
      - test: net/kafka/install
    - watch_in:
      - test: net/kafka/install
{% endif %}

{% if kafka.lookup.src_url %}
net/kafka/install/src_url:
  file.managed:
    - name: '/usr/local/{{ kafka.lookup.src_name }}.tgz'
    - source: {{ kafka.lookup.src_url }}
    - source_hash: {{ kafka.lookup.src_hash }}
    - skip_verify: True
    - require:
      - test: net/kafka/install/pre
    - require_in:
      - test: net/kafka/install
    - watch_in:
      - test: net/kafka/install

net/kafka/install/src_extract:
  cmd.run:
    - name: 'tar --cd /usr/local -xzf "/usr/local/{{ kafka.lookup.src_name }}.tgz"'
    - cwd: /usr/local
    - onchanges:
      - file: net/kafka/install/src_url
    - require:
      - test: net/kafka/install/pre
      - file: net/kafka/install/src_url
    - require_in:
      - test: net/kafka/install
    - watch_in:
      - test: net/kafka/install

net/kafka/install/src_link:
  cmd.run:
    - name: 'ln -s "/usr/local/{{ kafka.lookup.src_name }}" "{{ kafka.lookup.base_dir }}"'
    - unless: 'test -d "{{ kafka.lookup.base_dir }}"'
    - onchanges:
      - file: net/kafka/install/src_url
    - require:
      - test: net/kafka/install/pre
      - cmd: net/kafka/install/src_extract
    - require_in:
      - test: net/kafka/install
    - watch_in:
      - test: net/kafka/install

net/kafka/install/user:
  user.present:
    - name: kafka
    - fullname: Kafka service
    - system: True
{% endif %}

{% if grains['os'] == 'FreeBSD' %}
net/kafka/install/rc.d:
  file.managed:
    - name: /usr/local/etc/rc.d/kafka
    - source: salt://net/kafka/files/FreeBSD/kafka.rc.d
    - mode: 0555
    - template: jinja
    - defaults:
        kafka: {{ kafka }}
    - require:
      - test: net/kafka/install/pre
    - require_in:
      - test: net/kafka/install
    - watch_in:
      - test: net/kafka/install

net/kafka/install/etc:
  file.directory:
    - name: /usr/local/etc/kafka
    - require:
      - test: net/kafka/install/pre
    - require_in:
      - test: net/kafka/install
    - watch_in:
      - test: net/kafka/install
{% endif %}

