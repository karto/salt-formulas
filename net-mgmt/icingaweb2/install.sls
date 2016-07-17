{% from "net-mgmt/icingaweb2/map.jinja" import icingaweb2 with context %}

net-mgmt/icingaweb2/install/pre:
  test.succeed_without_changes:
    - require_in:
      - pkg: net-mgmt/icingaweb2/install/pkg
      - pkg: net-mgmt/icingaweb2/install/pkgs

net-mgmt/icingaweb2/install:
  test.succeed_without_changes:
    - require:
      - pkg: net-mgmt/icingaweb2/install/pkg
      - pkg: net-mgmt/icingaweb2/install/pkgs
    - watch:
      - pkg: net-mgmt/icingaweb2/install/pkg
      - pkg: net-mgmt/icingaweb2/install/pkgs


net-mgmt/icingaweb2/install/pkg:
  pkg.installed:
    - name: {{ icingaweb2.lookup.pkg }}

net-mgmt/icingaweb2/install/pkgs:
  pkg.installed:
    - pkgs:
      - pecl-intl
      - pecl-imagick
      - php56-pgsql



{% if grains['os'] == 'FreeBSD' %}

{% endif %}

