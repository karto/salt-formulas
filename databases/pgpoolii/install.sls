{% from "databases/pgpoolii/map.jinja" import pgpoolii with context %}

databases/pgpoolii/install/pre:
  test.succeed_without_changes:
    - require_in:
      - pkg: databases/pgpoolii/install/pkg

databases/pgpoolii/install:
  test.succeed_without_changes:
    - require:
      - pkg: databases/pgpoolii/install/pkg
    - watch:
      - pkg: databases/pgpoolii/install/pkg



databases/pgpoolii/install/pkg:
  pkg.installed:
    - name: {{ pgpoolii.lookup.pkg }}

{% if grains['os'] == 'FreeBSD' %}

{% endif %}

