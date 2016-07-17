{% from "security/certificates/map.jinja" import certificates with context %}
{% import 'statehelper.sls' as statehelper %}


security/certificates/config/pre:
  test.succeed_without_changes:
    - require_in:
      - file: security/certificates/config/certs
      - file: security/certificates/config/private

security/certificates/config:
  test.succeed_without_changes:
    - require:
      - file: security/certificates/config/certs
      - file: security/certificates/config/private
    - watch:
      - file: security/certificates/config/certs
      - file: security/certificates/config/private


security/certificates/config/certs:
  file.recurse:
    - name: {{ certificates.lookup.certs_dir }}
    - source:
        {{ statehelper.statesource("security/certificates", "certs")|indent(6) }}
    - file_mode: 0644
    - dir_mode: 0755
    - exclude_pat: "E@(^|/)\\._|\\.sample$"
    - makedirs: true
    - template: jinja
    - defaults:
        certificates: {{ certificates }}

security/certificates/config/private:
  file.recurse:
    - name: {{ certificates.lookup.private_dir }}
    - source:
        {{ statehelper.statesource("security/certificates", "private")|indent(6) }}
    - file_mode: 0640
    - dir_mode: 0750
    - exclude_pat: "E@(^|/)\\._|\\.sample$"
    - makedirs: true
    - template: jinja
    - defaults:
        certificates: {{ certificates }}


