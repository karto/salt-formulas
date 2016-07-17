
{% if grains['os'] == 'RedHat' %}

sysutils/beats/pkgrepo:
  pkgrepo.managed:
    - name: beats
    - humanname: Elastic Beats Repository
    - baseurl: https://packages.elastic.co/beats/yum/el/$basearch
    - enabled: 1
    - gpgkey: https://packages.elastic.co/GPG-KEY-elasticsearch
    - gpgcheck: 1

{% endif %}
