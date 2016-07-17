{% from "sysutils/salt/minion/map.jinja" import salt_minion with context %}
{% import 'statehelper.sls' as statehelper %}

sysutils/salt/minion/config/pre:
  test.succeed_without_changes:
    - require_in:
      - file: sysutils/salt/minion/config/file
{% if grains['os'] == 'FreeBSD' %}
      - file: sysutils/salt/minion/config/newsyslog
{% endif %}

sysutils/salt/minion/config:
  test.succeed_without_changes:
    - require:
      - file: sysutils/salt/minion/config/file
{% if grains['os'] == 'FreeBSD' %}
      - file: sysutils/salt/minion/config/newsyslog
{% endif %}
    - watch:
      - file: sysutils/salt/minion/config/file
{% if grains['os'] == 'FreeBSD' %}
      - file: sysutils/salt/minion/config/newsyslog
{% endif %}


sysutils/salt/minion/config/file:
  file.managed:
    - name: {{ salt_minion.lookup.config_file }}
    - source:
        {{ statehelper.statesource("sysutils/salt", "minion")|indent(6) }}
    - template: jinja
    - defaults:
        salt_minion: {{ salt_minion }}
        
        
{% if grains['os'] == 'FreeBSD' %}
sysutils/salt/minion/config/newsyslog:
  file.managed:
    - name: /etc/newsyslog.conf.d/salt-minion.conf
    - contents: |
        # logfilename          [owner:group]    mode count size when  flags [/pid_file] [sig_num]
        /var/log/salt/minion   root:logstash    640  7     *    @T00  BJN
{% endif %}

