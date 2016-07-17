{% if grains['os'] == 'FreeBSD' %}
include:
  - www.p5-libwww
  - dns.p5-Net-DNS
  - net-mgmt.p5-Net-IP
{% endif %}

munin-node:
  pkg.latest:
    {% if grains['os'] == 'FreeBSD' %}
    - require:
      - pkg: p5-libwww
    {% endif %}
  
  cmd.wait:
    - name: munin-node-configure --shell | sh -x
    - watch:
      - pkg: munin-node
      - pkg: p5-libwww
  
  service.running:
    - enable: True
    - require:
      - cmd: munin-node

{% if grains['os'] == 'FreeBSD' %}
/usr/local/share/munin/plugins/processes:
  file.patch:
    - source: salt://sysutils/munin_processes.FreeBSD.patch
    - hash: md5=5a68638b544f29d944b0d28b12cf309c
{% endif %}
