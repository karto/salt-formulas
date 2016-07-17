{% from "emulators/open-vm-tools-nox11/map.jinja" import open_vm_tools_nox11 with context %}


emulators/open-vm-tools-nox11/service/pre:
  test.succeed_without_changes:
    - require_in:
      - service: emulators/open-vm-tools-nox11/service/service

emulators/open-vm-tools-nox11/service:
  test.succeed_without_changes:
    - require:
      - service: emulators/open-vm-tools-nox11/service/service
    - watch:
      - service: emulators/open-vm-tools-nox11/service/service


emulators/open-vm-tools-nox11/service/service:
  service.running:
    - name: {{ open_vm_tools_nox11.lookup.service }}

