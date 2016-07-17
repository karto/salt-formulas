

www/varnish/varnishdeploy:
  group.present:
    - name: varnishdeploy
    - system: True
  
  user.present:
    - name: varnishdeploy
    - gid_from_name: True
    - createhome: True
    - system: True
    - optional_groups:
      - varnishsecret
  
  alias.present:
    - name: varnishdeploy
    - target: root

www/varnish/varnishdeploy/.ssh:
  file.directory:
    - name: ~varnishdeploy/.ssh
    - user: varnishdeploy
    - group: varnishdeploy
    - mode: 0700
    - require:
      - user: www/varnish/varnishdeploy

www/varnish/varnishdeploy/id_rsa:
  file.managed:
    - name: ~varnishdeploy/.ssh/id_rsa
    - user: varnishdeploy
    - group: varnishdeploy
    - mode: 0600
    - contents_pillar: www:varnish:varnishdeploy:key
    - require:
      - file: www/varnish/varnishdeploy/.ssh

www/varnish/varnishdeploy/id_rsa.pub:
  file.managed:
    - name: ~varnishdeploy/.ssh/id_rsa.pub
    - user: varnishdeploy
    - group: varnishdeploy
    - mode: 0644
    - contents_pillar: www:varnish:varnishdeploy:pub
    - require:
      - file: www/varnish/varnishdeploy/.ssh

