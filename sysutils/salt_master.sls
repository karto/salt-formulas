{% set salt_master = salt['grains.filter_by']({
    'RedHat': {'package': 'salt-master', 'service': 'salt-master'},
    'Debian': {'package': 'salt-master', 'service': 'salt-master'},
    'FreeBSD': {'package': 'py27-salt', 'service': 'salt_master'},
    'default': 'RedHat',
}, merge=salt['pillar.get']('salt_master:lookup')) %}

salt_master:
  pkg.latest:
    - name: {{ salt_master.package }}
    
  service.running:
    - name: {{ salt_master.service }}
    - enable: True
    - watch:
      - pkg: salt_master
