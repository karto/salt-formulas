{% from "emulators/open-vm-tools-nox11/map.jinja" import open_vm_tools_nox11 with context %}


emulators/open-vm-tools-nox11/install/pre:
  test.succeed_without_changes:
    - require_in:
      - pkg: emulators/open-vm-tools-nox11/install/pkg

emulators/open-vm-tools-nox11/install:
  test.succeed_without_changes:
    - require:
      - pkg: emulators/open-vm-tools-nox11/install/pkg
    - watch:
      - pkg: emulators/open-vm-tools-nox11/install/pkg


emulators/open-vm-tools-nox11/install/pkg:
  pkg.installed:
    - name: {{ open_vm_tools_nox11.lookup.pkg }}
