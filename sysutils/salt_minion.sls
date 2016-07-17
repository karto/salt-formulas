{% set salt_minion = salt['grains.filter_by']({
    'RedHat': {'package': 'salt-minion', 'service': 'salt-minion'},
    'Debian': {'package': 'salt-minion', 'service': 'salt-minion'},
    'FreeBSD': {'package': 'py27-salt', 'service': 'salt_minion'},
    'default': 'RedHat',
}, merge=salt['pillar.get']('salt_minion:lookup')) %}

salt_minion:
  pkg.latest:
    - name: {{ salt_minion.package }}
    
  service.running:
    - name: {{ salt_minion.service }}
    - enable: True
    - watch:
      - pkg: salt_minion
