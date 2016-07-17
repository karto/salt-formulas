{% from "logstash/map.jinja" import logstash with context %}

include:
  - logstash.pkg
  

logstash/filter/pkg/pre:
  test.succeed_without_changes:
    - require:
      - test: logstash/pkg
{% if grains['os'] == 'FreeBSD' %}
    - require_in:
      - file: logstash/filter/pkg/rc.d
      - file: logstash/filter/pkg/conf
      - file: logstash/filter/pkg/log
      - file: logstash/filter/pkg/rotate
{% endif %}

logstash/filter/pkg:
  test.succeed_without_changes:
    - require:
      - test: logstash/filter/pkg/pre
{% if grains['os'] == 'FreeBSD' %}
      - file: logstash/filter/pkg/rc.d
      - file: logstash/filter/pkg/conf
      - file: logstash/filter/pkg/log
      - file: logstash/filter/pkg/rotate
{% endif %}
    - watch:
      - test: logstash/filter/pkg/pre
{% if grains['os'] == 'FreeBSD' %}
      - file: logstash/filter/pkg/rc.d
      - file: logstash/filter/pkg/conf
      - file: logstash/filter/pkg/log
      - file: logstash/filter/pkg/rotate
{% endif %}


{% if grains['os'] == 'FreeBSD' %}

logstash/filter/pkg/rc.d:
  file.managed:
    - name: /usr/local/etc/rc.d/logstash-filter
    - source: salt://logstash/files/FreeBSD.rc.d.logstash-filter
    - mode: 0755

logstash/filter/pkg/conf:
  file.managed:
    - name: /usr/local/etc/logstash/logstash-filter.conf
    - replace: false

logstash/filter/pkg/log:
  file.managed:
    - name: /var/log/logstash-filter.log
    - replace: false
    - user: logstash
    - group: logstash

logstash/filter/pkg/rotate:
  file.managed:
    - name: /etc/newsyslog.conf.d/logstash-filter.conf
    - contents: |
        # logfilename                 [owner:group]        mode count size when  flags [/pid_file] [sig_num]
        /var/log/logstash-filter.log   logstash:logstash    644  7     *    @T00  BJN

{% endif %}
