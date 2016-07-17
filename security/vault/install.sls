{% from "security/vault/map.jinja" import vault with context %}

security/vault/install/pre:
  test.succeed_without_changes:
    - require_in:
      - pkg: security/vault/install/pkg

security/vault/install:
  test.succeed_without_changes:
    - require:
      - pkg: security/vault/install/pkg
    - watch:
      - pkg: security/vault/install/pkg


security/vault/install/pkg:
  pkg.installed:
    - name: {{ vault.lookup.pkg }}


{% if grains['os'] == 'FreeBSD' %}

{% endif %}

