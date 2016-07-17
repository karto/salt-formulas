{% from "logstash/map.jinja" import logstash with context %}

logstash/receive/conf/pre:
  test.succeed_without_changes:
    - require_in:
      - file: logstash/receive/conf/receive.d
      - file: logstash/receive/conf/patterns
{% if grains['os'] == 'FreeBSD' %}
      - file: logstash/receive/conf/rc.conf.d
{% endif %}

logstash/receive/conf:
  test.succeed_without_changes:
    - require:
      - file: logstash/receive/conf/receive.d
      - file: logstash/receive/conf/patterns
{% if grains['os'] == 'FreeBSD' %}
      - file: logstash/receive/conf/rc.conf.d
{% endif %}
    - watch:
      - file: logstash/receive/conf/receive.d
      - file: logstash/receive/conf/patterns
{% if grains['os'] == 'FreeBSD' %}
      - file: logstash/receive/conf/rc.conf.d
{% endif %}


logstash/receive/conf/receive.d:
  file.recurse:
    - name: {{ logstash.lookup.config_dir }}/receive.d
    - source:
        {% for environment in pillar.get('environments', []) %}
        - salt://{{ environment }}/logstash/{{ grains.host }}/receive.d
        {% for cluster in pillar.get('clusters', []) %}
        - salt://{{ environment }}/logstash/{{ cluster }}/receive.d
        {% endfor %}
        - salt://{{ environment }}/logstash/receive.d
        {% endfor %}
        - salt://logstash/files/receive.d
    - clean: true
    - exclude_pat: "E@(^|/)\\._|\\.sample$"
    - include_empty: true
    - template: jinja
    - defaults:
        logstash: {{ logstash }}


logstash/receive/conf/patterns:
  file.recurse:
    - name: {{ logstash.lookup.patterns_dir }}
    - source:
        {% for environment in pillar.get('environments', []) %}
        - salt://{{ environment }}/logstash/{{ grains.host }}/patterns
        {% for cluster in pillar.get('clusters', []) %}
        - salt://{{ environment }}/logstash/{{ cluster }}/patterns
        {% endfor %}
        - salt://{{ environment }}/logstash/patterns
        {% endfor %}
        - salt://logstash/files/patterns
    - clean: true
    - exclude_pat: "E@(^|/)\\._|\\.sample$"
    - include_empty: true
    - template: jinja
    - defaults:
        logstash: {{ logstash }}


{% if grains['os'] == 'FreeBSD' %}

logstash/receive/conf/rc.conf.d:
  file.managed:
    - name: /etc/rc.conf.d/logstash_receive
    - contents: |
        logstash_receive_log="YES"
        logstash_receive_log_file="/var/log/logstash-receive.log"
        logstash_receive_config="{{ logstash.lookup.config_dir }}/receive.d"
        logstash_receive_user="logstash"
        logstash_receive_group="logstash"
        logstash_receive_opts=""
        # "--auto-reload"
{# %- if 'dokafkaoludv' in pillar.get('clusters', []) %}
        logstash_receive_opts="$logstash_receive_opts --pipeline-workers 8 --pipeline-batch-size 125"
{%- endif % #}

{% endif %}
