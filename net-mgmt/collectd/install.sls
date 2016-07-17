{% from "net-mgmt/collectd/map.jinja" import collectd with context %}


net-mgmt/collectd/install/pre:
  test.succeed_without_changes:
    - require_in:
      - pkg: net-mgmt/collectd/install/pkg

net-mgmt/collectd/install:
  test.succeed_without_changes:
    - require:
      - pkg: net-mgmt/collectd/install/pkg
    - watch:
      - pkg: net-mgmt/collectd/install/pkg


net-mgmt/collectd/install/pkg:
  pkg.installed:
    - name: {{ collectd.lookup.pkg }}


{% if collectd.lookup.extra_pkgs %}
net-mgmt/collectd/install/plugins:
  pkg.installed:
    - pkgs: {{ collectd.lookup.extra_pkgs }}
    - require:
      - pkg: net-mgmt/collectd/install/pkg
    - require_in:
      - test: net-mgmt/collectd/install
    - watch_in:
      - test: net-mgmt/collectd/install
{% endif %}

