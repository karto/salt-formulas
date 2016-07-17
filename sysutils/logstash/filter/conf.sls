{% from "logstash/map.jinja" import logstash with context %}

logstash/filter/conf/pre:
  test.succeed_without_changes:
    - require_in:
      - file: logstash/filter/conf/filter.d
      - file: logstash/filter/conf/patterns
      - file: logstash/filter/conf/elasticsearch_templates
{% if grains['os'] == 'FreeBSD' %}
      - file: logstash/filter/conf/rc.conf.d
{% endif %}

logstash/filter/conf:
  test.succeed_without_changes:
    - require:
      - file: logstash/filter/conf/filter.d
      - file: logstash/filter/conf/patterns
      - file: logstash/filter/conf/elasticsearch_templates
{% if grains['os'] == 'FreeBSD' %}
      - file: logstash/filter/conf/rc.conf.d
{% endif %}
    - watch:
      - file: logstash/filter/conf/filter.d
      - file: logstash/filter/conf/patterns
      - file: logstash/filter/conf/elasticsearch_templates
{% if grains['os'] == 'FreeBSD' %}
      - file: logstash/filter/conf/rc.conf.d
{% endif %}


logstash/filter/conf/filter.d:
  file.recurse:
    - name: {{ logstash.lookup.config_dir }}/filter.d
    - source:
        {% for environment in pillar.get('environments', []) %}
        - salt://{{ environment }}/logstash/{{ grains.host }}/filter.d
        {% for cluster in pillar.get('clusters', []) %}
        - salt://{{ environment }}/logstash/{{ cluster }}/filter.d
        {% endfor %}
        - salt://{{ environment }}/logstash/filter.d
        {% endfor %}
        - salt://logstash/files/filter.d
    - clean: true
    - exclude_pat: "E@(^|/)\\._|\\.sample$"
    - include_empty: true
    - template: jinja
    - defaults:
        logstash: {{ logstash }}


logstash/filter/conf/patterns:
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

logstash/filter/conf/elasticsearch_templates:
  file.recurse:
    - name: {{ logstash.lookup.elasticsearch_templates_dir }}
    - source:
        {% for environment in pillar.get('environments', []) %}
        - salt://{{ environment }}/logstash/{{ grains.host }}/elasticsearch_templates
        {% for cluster in pillar.get('clusters', []) %}
        - salt://{{ environment }}/logstash/{{ cluster }}/elasticsearch_templates
        {% endfor %}
        - salt://{{ environment }}/logstash/elasticsearch_templates
        {% endfor %}
        - salt://logstash/files/elasticsearch_templates
    - clean: true
    - exclude_pat: "E@(^|/)\\._|\\.sample$"
    - include_empty: true
    - template: jinja
    - defaults:
        logstash: {{ logstash }}



{% if grains['os'] == 'FreeBSD' %}

logstash/filter/conf/rc.conf.d:
  file.managed:
    - name: /etc/rc.conf.d/logstash_filter
    - contents: |
        logstash_filter_log="YES"
        logstash_filter_log_file="/var/log/logstash-filter.log"
        logstash_filter_config="{{ logstash.lookup.config_dir }}/filter.d"
        logstash_filter_user="logstash"
        logstash_filter_group="logstash"
        logstash_filter_opts=""
        # "--auto-reload"
{# %- if 'dokafkaoludv' in pillar.get('clusters', []) %}
        logstash_filter_opts="$logstash_filter_opts --pipeline-workers 8 --pipeline-batch-size 125"
{%- endif % #}

{% endif %}
