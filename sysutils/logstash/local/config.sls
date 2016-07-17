{% from "sysutils/logstash/map.jinja" import logstash with context %}

sysutils/logstash/local/config/pre:
  test.succeed_without_changes:
    - require_in:
      - file: sysutils/logstash/local/config/local.d
      - file: sysutils/logstash/local/config/patterns
{% if grains['os'] == 'FreeBSD' %}
      - file: sysutils/logstash/local/config/rc.conf.d
{% endif %}

sysutils/logstash/local/config:
  test.succeed_without_changes:
    - require:
      - file: sysutils/logstash/local/config/local.d
      - file: sysutils/logstash/local/config/patterns
{% if grains['os'] == 'FreeBSD' %}
      - file: sysutils/logstash/local/config/rc.conf.d
{% endif %}
    - watch:
      - file: sysutils/logstash/local/config/local.d
      - file: sysutils/logstash/local/config/patterns
{% if grains['os'] == 'FreeBSD' %}
      - file: sysutils/logstash/local/config/rc.conf.d
{% endif %}


sysutils/logstash/local/config/local.d:
  file.recurse:
    - name: {{ logstash.lookup.config_dir }}/local.d
    - source:
        {% for environment in pillar.get('environments', []) %}
        - salt://{{ environment }}/sysutils/logstash/{{ grains.host }}/local.d
        {% for cluster in pillar.get('clusters', []) %}
        - salt://{{ environment }}/sysutils/logstash/{{ cluster }}/local.d
        {% endfor %}
        - salt://{{ environment }}/sysutils/logstash/local.d
        {% endfor %}
        - salt://sysutils/logstash/files/local.d
    - clean: true
    - exclude_pat: "E@(^|/)\\._|\\.sample$"
    - include_empty: true
    - template: jinja
    - defaults:
        logstash: {{ logstash }}


sysutils/logstash/local/config/patterns:
  file.recurse:
    - name: {{ logstash.lookup.patterns_dir }}
    - source:
        {% for environment in pillar.get('environments', []) %}
        - salt://{{ environment }}/sysutils/logstash/{{ grains.host }}/patterns
        {% for cluster in pillar.get('clusters', []) %}
        - salt://{{ environment }}/sysutils/logstash/{{ cluster }}/patterns
        {% endfor %}
        - salt://{{ environment }}/sysutils/logstash/patterns
        {% endfor %}
        - salt://sysutils/logstash/files/patterns
    - clean: true
    - exclude_pat: "E@(^|/)\\._|\\.sample$"
    - include_empty: true
    - template: jinja
    - defaults:
        logstash: {{ logstash }}


{% if grains['os'] == 'FreeBSD' %}

sysutils/logstash/local/config/rc.conf.d:
  file.managed:
    - name: /etc/rc.conf.d/logstash_local
    - contents: |
        logstash_local_log="YES"
        logstash_local_log_file="/var/log/logstash-local.log"
        logstash_local_config="{{ logstash.lookup.config_dir }}/local.d"
        logstash_local_user="logstash"
        logstash_local_group="logstash"
        logstash_local_opts=""
        # "--auto-reload"
{# %- if 'dokafkaoludv' in pillar.get('clusters', []) %}
        logstash_local_opts="$logstash_local_opts --pipeline-workers 8 --pipeline-batch-size 125"
{%- endif % #}

{% endif %}
