

www/varnish/varnishsecret:
  group.present:
    - name: varnishsecret
    - system: True
  
  user.present:
    - name: varnishsecret
    - gid_from_name: True
    - createhome: True
    - system: True
  
  alias.present:
    - name: varnishsecret
    - target: root

