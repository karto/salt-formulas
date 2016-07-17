{% from "security/certificates/map.jinja" import certificates with context %}

security/certificates/install/pre:
  test.succeed_without_changes:
    - require_in:
      - file: security/certificates/install/certs
      - file: security/certificates/install/private

security/certificates/install:
  test.succeed_without_changes:
    - require:
      - file: security/certificates/install/certs
      - file: security/certificates/install/private
    - watch:
      - file: security/certificates/install/certs
      - file: security/certificates/install/private


security/certificates/install/certs:
  file.directory:
    - name: {{ certificates.lookup.certs_dir }}
    - file_mode: 0644
    - dir_mode: 0755
    - makedirs: true

security/certificates/install/private:
  file.directory:
    - name: {{ certificates.lookup.private_dir }}
    - file_mode: 0640
    - dir_mode: 0751
    - makedirs: true


