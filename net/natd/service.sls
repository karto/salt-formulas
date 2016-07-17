{% from "net/natd/map.jinja" import natd with context %}

net/natd/service/pre:
  test.succeed_without_changes:
    - require_in:
      - file: net/natd/service/rc

net/natd/service:
  test.succeed_without_changes:
    - require:
      - file: net/natd/service/rc
    - watch:
      - file: net/natd/service/rc


net/natd/service/rc:
  file.append:
    - name: /etc/rc.conf
    - text: |
        natd_enable="YES"
        natd_flags="-f /etc/natd.conf"
