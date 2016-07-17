{% from "security/ipfw/map.jinja" import ipfw with context %}

security/ipfw/service/pre:
  test.succeed_without_changes:
    - require_in:
      - file: security/ipfw/service/rc

security/ipfw/service:
  test.succeed_without_changes:
    - require:
      - file: security/ipfw/service/rc
    - watch:
      - file: security/ipfw/service/rc


security/ipfw/service/rc:
  file.append:
    - name: /etc/rc.conf
    - text: |
        firewall_enable="YES"
        firewall_nat_enable="YES"
        firewall_script="/etc/ipfw.rules"
