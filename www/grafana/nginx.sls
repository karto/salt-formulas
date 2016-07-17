{% from "grafana/map.jinja" import grafana with context %}

grafana/nginx:
  file.managed:
    - name: {{ grafana.lookup.config_nginx }}
    - makedirs: True
    - source:
        {% for environment in pillar.get('environments', []) %}
        {% for cluster in pillar.get('clusters', []) %}
        - salt://{{ environment }}/grafana/nginx-{{ cluster }}.conf
        {% endfor %}
        - salt://{{ environment }}/grafana/nginx.conf
        {% endfor %}
        - salt://grafana/files/nginx.conf
    - template: jinja
    - defaults:
        grafana: {{ grafana }}

