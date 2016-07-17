
include:
  - emulators.open-vm-tools-nox11.install
  - emulators.open-vm-tools-nox11.config
  - emulators.open-vm-tools-nox11.service

extend:
  emulators/open-vm-tools-nox11/config/pre:
    test.succeed_without_changes:
      - require:
        - test: emulators/open-vm-tools-nox11/install
      - watch:
        - test: emulators/open-vm-tools-nox11/install
  
  emulators/open-vm-tools-nox11/service/pre:
    test.succeed_without_changes:
      - require:
        - test: emulators/open-vm-tools-nox11/config
      - watch:
        - test: emulators/open-vm-tools-nox11/config
