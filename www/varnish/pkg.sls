{% from "www/varnish/map.jinja" import varnish with context %}


www/varnish/pkg/pre:
  test.succeed_without_changes:
    - require_in:
      - pkg: www/varnish/pkg/install

www/varnish/pkg:
  test.succeed_without_changes:
    - require:
      - pkg: www/varnish/pkg/install
    - watch:
      - pkg: www/varnish/pkg/install


www/varnish/pkg/install:
  pkg.installed:
    - name: {{ varnish.lookup.pkg }}


{% if varnish.lookup.extra_pkgs %}
www/varnish/pkg/extras:
  pkg.installed:
    - pkgs: {{ varnish.lookup.extra_pkgs }}
    - require:
      - pkg: www/varnish/pkg/install
    - require_in:
      - test: www/varnish/pkg
    - watch_in:
      - test: www/varnish/pkg
{% endif %}


{% if varnish.lookup.pkgrepo %}
www/varnish/pkg/pkgrepo:
  pkgrepo.managed:
    - name: {{ varnish.lookup.pkgrepo.name }}
{% if grains['os_family'] == 'RedHat' %}
    - humanname: {{ varnish.lookup.pkgrepo.humanname }}
    - baseurl: {{ varnish.lookup.pkgrepo.baseurl }}
    - enabled: 1
    - gpgcheck: 0
{% endif %}
    - require:
      - test: www/varnish/pkg/pre
    - require_in:
      - pkg: www/varnish/pkg/install
    - watch_in:
      - pkg: www/varnish/pkg/install
{% endif %}
