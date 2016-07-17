{% from "logstash/map.jinja" import logstash with context %}

include:
  - logstash.pkg
  

logstash/receive/pkg/pre:
  test.succeed_without_changes:
    - require:
      - test: logstash/pkg
{% if grains['os'] == 'FreeBSD' %}
    - require_in:
      - file: logstash/receive/pkg/rc.d
      - file: logstash/receive/pkg/conf
      - file: logstash/receive/pkg/log
      - file: logstash/receive/pkg/rotate
{% endif %}

logstash/receive/pkg:
  test.succeed_without_changes:
    - require:
      - test: logstash/receive/pkg/pre
{% if grains['os'] == 'FreeBSD' %}
      - file: logstash/receive/pkg/rc.d
      - file: logstash/receive/pkg/conf
      - file: logstash/receive/pkg/log
      - file: logstash/receive/pkg/rotate
{% endif %}
    - watch:
      - test: logstash/receive/pkg/pre
{% if grains['os'] == 'FreeBSD' %}
      - file: logstash/receive/pkg/rc.d
      - file: logstash/receive/pkg/conf
      - file: logstash/receive/pkg/log
      - file: logstash/receive/pkg/rotate
{% endif %}


{% if grains['os'] == 'FreeBSD' %}

logstash/receive/pkg/rc.d:
  file.managed:
    - name: /usr/local/etc/rc.d/logstash-receive
    - source: salt://logstash/files/FreeBSD.rc.d.logstash-receive
    - mode: 0755

logstash/receive/pkg/conf:
  file.managed:
    - name: /usr/local/etc/logstash/logstash-receive.conf
    - replace: false

logstash/receive/pkg/log:
  file.managed:
    - name: /var/log/logstash-receive.log
    - replace: false
    - user: logstash
    - group: logstash

logstash/receive/pkg/rotate:
  file.managed:
    - name: /etc/newsyslog.conf.d/logstash-receive.conf
    - contents: |
        # logfilename                 [owner:group]        mode count size when  flags [/pid_file] [sig_num]
        /var/log/logstash-receive.log   logstash:logstash    644  7     *    @T00  BJN

{% endif %}
