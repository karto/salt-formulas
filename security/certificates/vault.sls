{% from "security/certificates/map.jinja" import certificates with context %}

security/certificates/vault/pkgs:
  pkg.installed:
    - pkgs: 
      - jq
      - curl
      - openssl

{% for name, issue in certificates.vault.issue.iteritems() %}

{% set addr = issue.get('addr', certificates.vault.get('addr', 'https://vault:8200')) %}
{% set path = issue.get('path', certificates.vault.get('path', 'pki')) %}
{% set role = issue.get('role', certificates.vault.get('role', 'salt_minion')) %}
{% set token = issue.get('token', certificates.vault.get('token', '')) %}
{% set url = "%s/v1/%s/issue/%s"|format(addr, path, role) %}
{% set data = issue.params|json|replace('"','\\"') %}
{% set basefilepath = "%s/%s"|format(certificates.lookup.private_dir, name) %}
{% set curl = 'curl -skLX POST -H "X-Vault-Token:%s" -d "%s" -o "%s.json" %s'|format(token, data, basefilepath, url|yaml_dquote) %}
{% set cmd = "%s"|format(curl) %}

security/certificates/vault/{{ name }}/json/curl:
  cmd.run:
    - name: '{{ cmd }}'
    - creates: {{ basefilepath }}.json

security/certificates/vault/{{ name }}/json/test/invalid:
  cmd.run:
    - name: 'jq . "{{ basefilepath }}.json" ; rm "{{ basefilepath }}.json" ; return 1'
    - unless: jq -re . "{{ basefilepath }}.json"
    - onchanges:
      - cmd: security/certificates/vault/{{ name }}/json/curl
    - require:
      - cmd: security/certificates/vault/{{ name }}/json/curl

security/certificates/vault/{{ name }}/json/test/error:
  cmd.run:
    - name: 'jq . "{{ basefilepath }}.json" ; rm "{{ basefilepath }}.json" ; return 1'
    - onlyif: jq -re .errors "{{ basefilepath }}.json"
    - onchanges:
      - cmd: security/certificates/vault/{{ name }}/json/curl
    - require:
      - cmd: security/certificates/vault/{{ name }}/json/curl

security/certificates/vault/{{ name }}/json/managed:
  file.managed:
    - name: {{ basefilepath }}.json
    - mode: 0640
    - replace: False
    - create: False
    - allow_empty: False
    - onchanges:
      - cmd: security/certificates/vault/{{ name }}/json/curl
    - require:
      - cmd: security/certificates/vault/{{ name }}/json/curl
      - cmd: security/certificates/vault/{{ name }}/json/test/invalid
      - cmd: security/certificates/vault/{{ name }}/json/test/error

security/certificates/vault/{{ name }}/crt/test:
  cmd.run:
    - name: test -n "`jq -e .data.certificate {{ basefilepath }}.json`"
    - onchanges:
      - cmd: security/certificates/vault/{{ name }}/json/curl
    - require:
      - file: security/certificates/vault/{{ name }}/json/managed

security/certificates/vault/{{ name }}/crt/extract:
  cmd.run:
    - name: jq -r .data.certificate {{ basefilepath }}.json | openssl x509 -text > {{ certificates.lookup.certs_dir }}/{{ name }}.crt
    - onchanges:
      - cmd: security/certificates/vault/{{ name }}/json/curl
    - require:
      - cmd: security/certificates/vault/{{ name }}/crt/test

security/certificates/vault/{{ name }}/crt/managed:
  file.managed:
    - name: {{ certificates.lookup.certs_dir }}/{{ name }}.crt
    - mode: 0664
    - replace: False
    - create: False
    - allow_empty: False
    - onchanges:
      - cmd: security/certificates/vault/{{ name }}/json/curl
    - require:
      - cmd: security/certificates/vault/{{ name }}/crt/extract

security/certificates/vault/{{ name }}/key/test:
  cmd.run:
    - name: test -n "`jq -e .data.private_key {{ basefilepath }}.json`"
    - onchanges:
      - cmd: security/certificates/vault/{{ name }}/json/curl
    - require:
      - file: security/certificates/vault/{{ name }}/json/managed

security/certificates/vault/{{ name }}/key/extract:
  cmd.run:
    - name: jq -r .data.private_key {{ basefilepath }}.json > {{ basefilepath }}.key
    - onchanges:
      - cmd: security/certificates/vault/{{ name }}/json/curl
    - require:
      - cmd: security/certificates/vault/{{ name }}/crt/extract
      - cmd: security/certificates/vault/{{ name }}/key/test

security/certificates/vault/{{ name }}/key/managed:
  file.managed:
    - name: {{ basefilepath }}.key
    - group: {{ issue.get('group', certificates.vault.get('group', 'wheel')) }}
    - mode: 0640
    - replace: False
    - create: False
    - allow_empty: False
    - onchanges:
      - cmd: security/certificates/vault/{{ name }}/json/curl
    - require:
      - cmd: security/certificates/vault/{{ name }}/key/extract


{% endfor %}
