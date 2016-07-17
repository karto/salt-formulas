{% from "www/nginx/map.jinja" import nginx with context %}


www/nginx/install/pre:
  test.succeed_without_changes:
    - require_in:
      - pkg: www/nginx/install/pkg

www/nginx/install:
  test.succeed_without_changes:
    - require:
      - pkg: www/nginx/install/pkg
    - watch:
      - pkg: www/nginx/install/pkg


www/nginx/install/pkg:
  pkg.installed:
    - name: {{ nginx.lookup.pkg }}


{% if grains['os'] == 'RedHat' %}

www/nginx/install/RedHat/nginx_signing.key:
  file.managed:
    - name: /etc/pki/rpm-gpg/nginx_signing.key
    - source: salt://www/nginx/files/nginx_signing.key

www/nginx/install/RedHat/installrepo:
  pkgrepo.managed:
    - name: nginx
    - humanname: nginx repo
    - baseurl: http://nginx.org/packages/rhel/{{ grains['osmajorrelease'] }}/$basearch/
    - gpgkey: file:///etc/pki/rpm-gpg/nginx_signing.key
    - gpgcheck: 1
    - require:
      - file: www/nginx/install/RedHat/nginx_signing.key
      - test: www/nginx/install/pre
    - watch:
      - file: www/nginx/install/RedHat/nginx_signing.key
    - require_in:
      - pkg: www/nginx/install
    - watch_in:
      - pkg: www/nginx/install

{% endif %}
