{% from "security/certificates/map.jinja" import certificates with context %}

security/certificates/ca-root/pkgs:
  pkg.installed:
    - pkgs: 
      - ca_root_nss
      - curl
      - openssl

{% if certificates.roots %}

{% for name, url in certificates.roots.iteritems() %}
devops-udv/certificates/roots/{{ name }}:
  cmd.run:
    - name: curl -fskL "{{ url }}" | openssl x509 -text > {{ certificates.lookup.certs_dir }}/{{ name }}.crt || rm {{ certificates.lookup.certs_dir }}/{{ name }}.crt
    - creates: {{ certificates.lookup.certs_dir }}/{{ name }}.crt
    - require:
      - pkg: security/certificates/ca-root/pkgs
    - onchanges_in:
      - cmd: devops-udv/certificates/roots/ca-bundle
    - require_in:
      - cmd: devops-udv/certificates/roots/ca-bundle
{% endfor %}

devops-udv/certificates/roots/ca-bundle:
  cmd.run:
    - name: cat {% for name,url in certificates.roots.iteritems() %}{{ certificates.lookup.certs_dir }}/{{ name }}.crt {% endfor %}> {{ certificates.lookup.certs_dir }}/ca-bundle.crt

devops-udv/certificates/roots/ca-root-dist:
  cmd.run:
    - name: mv /usr/local/share/certs/ca-root-nss.crt /usr/local/share/certs/ca-root-nss-dist.crt
    - creates: /usr/local/share/certs/ca-root-nss-dist.crt

devops-udv/certificates/roots/ca-root-custom:
  cmd.run:
    - name: cat {{ certificates.lookup.certs_dir }}/ca-bundle.crt /usr/local/share/certs/ca-root-nss-dist.crt > /etc/ssl/ca-root-custom.pem
    - onchanges:
      - cmd: devops-udv/certificates/roots/ca-bundle
    - require:
      - cmd: devops-udv/certificates/roots/ca-bundle
      - cmd: devops-udv/certificates/roots/ca-root-dist

devops-udv/certificates/roots/etc-cert:
  file.symlink:
    - name: /etc/ssl/cert.pem
    - target: /etc/ssl/ca-root-custom.pem
    - backupname: /etc/ssl/cert.pem.salt
    - require:
      - cmd: devops-udv/certificates/roots/ca-root-custom

devops-udv/certificates/roots/usr-cert:
  file.symlink:
    - name: /usr/local/etc/ssl/cert.pem
    - target: /etc/ssl/ca-root-custom.pem
    - backupname: /usr/local/etc/ssl/cert.pem.salt
    - require:
      - cmd: devops-udv/certificates/roots/ca-root-custom

devops-udv/certificates/roots/ssl-cert:
  file.symlink:
    - name: /usr/local/openssl/cert.pem
    - target: /etc/ssl/ca-root-custom.pem
    - backupname: /usr/local/openssl/cert.pem.salt
    - require:
      - cmd: devops-udv/certificates/roots/ca-root-custom

devops-udv/certificates/roots/ca-root-nss:
  file.symlink:
    - name: /usr/local/share/certs/ca-root-nss.crt
    - target: /etc/ssl/ca-root-custom.pem
    - backupname: /usr/local/share/certs/ca-root-nss.crt.salt
    - require:
      - cmd: devops-udv/certificates/roots/ca-root-custom


{% endif %}


