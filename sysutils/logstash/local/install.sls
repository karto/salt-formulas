{% from "sysutils/logstash/map.jinja" import logstash with context %}

include:
  - sysutils.logstash.install
  

sysutils/logstash/local/install/pre:
  test.succeed_without_changes:
    - require:
      - test: sysutils/logstash/install
{% if grains['os'] == 'FreeBSD' %}
    - require_in:
      - file: sysutils/logstash/local/install/rc.d
      - file: sysutils/logstash/local/install/conf
      - file: sysutils/logstash/local/install/log
      - file: sysutils/logstash/local/install/rotate
      - file: sysutils/logstash/local/install/syslog/log
      - file: sysutils/logstash/local/install/syslog/conf
      - file: sysutils/logstash/local/install/syslog/rotate
{% endif %}

sysutils/logstash/local/install:
  test.succeed_without_changes:
    - require:
      - test: sysutils/logstash/local/install/pre
{% if grains['os'] == 'FreeBSD' %}
      - file: sysutils/logstash/local/install/rc.d
      - file: sysutils/logstash/local/install/conf
      - file: sysutils/logstash/local/install/log
      - file: sysutils/logstash/local/install/rotate
      - file: sysutils/logstash/local/install/syslog/log
      - file: sysutils/logstash/local/install/syslog/conf
      - file: sysutils/logstash/local/install/syslog/rotate
{% endif %}
    - watch:
      - test: sysutils/logstash/local/install/pre
{% if grains['os'] == 'FreeBSD' %}
      - file: sysutils/logstash/local/install/rc.d
      - file: sysutils/logstash/local/install/conf
      - file: sysutils/logstash/local/install/log
      - file: sysutils/logstash/local/install/rotate
      - file: sysutils/logstash/local/install/syslog/log
      - file: sysutils/logstash/local/install/syslog/conf
      - file: sysutils/logstash/local/install/syslog/rotate
{% endif %}



{% if grains['os'] == 'FreeBSD' %}

sysutils/logstash/local/install/rc.d:
  file.managed:
    - name: /usr/local/etc/rc.d/logstash-local
    - source: salt://sysutils/logstash/files/FreeBSD.rc.d.logstash-local
    - mode: 0755

sysutils/logstash/local/install/conf:
  file.managed:
    - name: /usr/local/etc/sysutils/logstash/logstash-local.conf
    - replace: false

sysutils/logstash/local/install/log:
  file.managed:
    - name: /var/log/logstash-local.log
    - replace: false
    - user: logstash
    - group: logstash

sysutils/logstash/local/install/rotate:
  file.managed:
    - name: /etc/newsyslog.conf.d/logstash-local.conf
    - contents: |
        # logfilename                 [owner:group]        mode count size when  flags [/pid_file] [sig_num]
        /var/log/logstash-local.log   logstash:logstash    644  7     *    @T00  BJN


sysutils/logstash/local/install/syslog/log:
  file.managed:
    - name: /var/log/forward.log
    - user: root
    - group: logstash
    - mode: 0644

sysutils/logstash/local/install/syslog/conf:
  file.append:
    - name: /etc/syslog.conf
    - text: |
        *.*                                             /var/log/forward.log

sysutils/logstash/local/install/syslog/rotate:
  file.managed:
    - name: /etc/newsyslog.conf.d/forward_log.conf
    - contents: |
        # logfilename          [owner:group]    mode count size when  flags [/pid_file] [sig_num]
        /var/log/forward.log   root:logstash    644  7     *    @T00  J


{% endif %}
