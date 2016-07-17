{% from "www/graphite/map.jinja" import graphite with context %}

www/graphite/install/pre:
  test.succeed_without_changes:
    - require_in:
      - pkg: www/graphite/install/pkg
      - user: www/graphite/install/user
      - file: www/graphite/install/db_dir
      - file: www/graphite/install/log_dir

www/graphite/install:
  test.succeed_without_changes:
    - require:
      - pkg: www/graphite/install/pkg
      - user: www/graphite/install/user
      - file: www/graphite/install/db_dir
      - file: www/graphite/install/log_dir
    - watch:
      - pkg: www/graphite/install/pkg
      - user: www/graphite/install/user
      - file: www/graphite/install/db_dir
      - file: www/graphite/install/log_dir

www/graphite/install/pkg:
  pkg.installed:
    - name: {{ graphite.lookup.pkg }}

www/graphite/install/user:
  user.present:
    - name: graphite
    - fullname: Graphite web service
    - system: True
    - optional_groups:
      - carbon

www/graphite/install/db_dir:
  file.directory:
    - name: /var/db/graphite
    - user: graphite
    - group: graphite

www/graphite/install/log_dir:
  file.directory:
    - name: /var/db/graphite
    - user: graphite
    - group: graphite

{% if graphite.lookup.ekstra_pkgs %}
www/graphite/install/ekstra_pkgs:
  pkg.installed:
    - pkgs: {{ graphite.lookup.ekstra_pkgs }}
    - require:
      - test: www/graphite/install/pre
    - require_in:
      - test: www/graphite/install
    - watch_in:
      - test: www/graphite/install
{% endif %}

{% if grains['os'] == 'FreeBSD' %}

{% endif %}

