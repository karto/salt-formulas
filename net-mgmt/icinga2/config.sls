{% from "net-mgmt/icinga2/map.jinja" import icinga2 with context %}
{% import 'statehelper.sls' as statehelper %}

net-mgmt/icinga2/config/pre:
  test.succeed_without_changes

net-mgmt/icinga2/config:
  test.succeed_without_changes

{% for conffile in ['icinga2.conf','constants.conf','init.conf','zones.conf'] %}
net-mgmt/icinga2/config/{{ conffile }}:
  file.managed:
    - name: {{ icinga2.lookup.config_dir }}/{{ conffile }}
    - source:
        {{ statehelper.statesource("net-mgmt/icinga2", conffile)|indent(6) }}
    - template: jinja
    - defaults:
        icinga2: {{ icinga2 }}
    - require:
      - test: net-mgmt/icinga2/config/pre
    - require_in:
      - test: net-mgmt/icinga2/config
    - watch_in:
      - test: net-mgmt/icinga2/config
{% endfor %}

{% for confdir in ['conf.d', 'local.d','zones.d', 'scripts', 'features-available'] %}
net-mgmt/icinga2/config/{{ confdir }}:
  file.recurse:
    - name: {{ icinga2.lookup.config_dir }}/{{ confdir }}
    - source:
        {{ statehelper.statesource("net-mgmt/icinga2", confdir)|indent(6) }}
    {% if confdir not in ["scripts", "features-available"] %}
    - clean: true
    {% endif %}
    - exclude_pat: "E@(^|/)\\._|\\.sample$"
    - keep_symlinks: false
    - include_empty: true
    - template: jinja
    - defaults:
        icinga2: {{ icinga2 }}
    - require:
      - test: net-mgmt/icinga2/config/pre
    - require_in:
      - test: net-mgmt/icinga2/config
    - watch_in:
      - test: net-mgmt/icinga2/config
{% endfor %}


net-mgmt/icinga2/config/pki:
  file.recurse:
    - name: {{ icinga2.lookup.config_dir }}/pki
    - source:
        {{ statehelper.statesource("net-mgmt/icinga2", 'pki')|indent(6) }}
    - user: icinga
    - group: icinga
    - include_pat: E@\.crt$|{{ grains.fqdn }}.key$
    - keep_symlinks: true
    - include_empty: true
    - template: jinja
    - defaults:
        icinga2: {{ icinga2 }}
    - require:
      - test: net-mgmt/icinga2/config/pre
    - require_in:
      - test: net-mgmt/icinga2/config
    - watch_in:
      - test: net-mgmt/icinga2/config


net-mgmt/icinga2/config/plugin_dir:
  file.recurse:
    - name: {{ icinga2.lookup.plugin_dir }}
    - source:
        {{ statehelper.statesource("net-mgmt/icinga2", 'plugins')|indent(6) }}
    - file_mode: 755
    - dir_mode: 755
    - exclude_pat: "E@(^|/)\\._|\\.sample$"
    - keep_symlinks: true
    - include_empty: true
    - template: jinja
    - defaults:
        icinga2: {{ icinga2 }}
    - require:
      - test: net-mgmt/icinga2/config/pre
    - require_in:
      - test: net-mgmt/icinga2/config
    - watch_in:
      - test: net-mgmt/icinga2/config



net-mgmt/icinga2/config/features-enabled:
  file.recurse:
    - name: {{ icinga2.lookup.config_dir }}/features-enabled
    - source: salt://net-mgmt/icinga2/files/features-enabled
    - clean: true

{% for feature in icinga2.features_enabled %}
net-mgmt/icinga2/config/features-enabled/{{ feature }}:
  file.symlink:
    - name: {{ icinga2.lookup.config_dir }}/features-enabled/{{ feature }}.conf
    - target: {{ icinga2.lookup.config_dir }}/features-available/{{ feature }}.conf
    - require_in:
      - file: net-mgmt/icinga2/config/features-enabled
{% endfor %}

