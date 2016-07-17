{% from "emulators/open-vm-tools-nox11/map.jinja" import open_vm_tools_nox11 with context %}

emulators/open-vm-tools-nox11/config/pre:
  test.succeed_without_changes:
    - require_in:
      - file: emulators/open-vm-tools-nox11/config/rc

emulators/open-vm-tools-nox11/config:
  test.succeed_without_changes:
    - require:
      - file: emulators/open-vm-tools-nox11/config/rc
    - watch:
      - file: emulators/open-vm-tools-nox11/config/rc

emulators/open-vm-tools-nox11/config/rc:
  file.managed:
    - name: /etc/rc.conf.d/vmware_guest
    - contents: |
        vmware_guest_vmblock_enable="YES"
        vmware_guest_vmhgfs_enable="YES"
        vmware_guest_vmmemctl_enable="YES"
        vmware_guest_vmxnet_enable="YES"
        vmware_guestd_enable="YES"

