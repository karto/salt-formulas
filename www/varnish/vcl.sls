{% from "www/varnish/map.jinja" import varnish with context %}
{% import 'statehelper.sls' as statehelper %}

include:
  - www.varnish.varnishsecret
  - www.varnish.varnishdeploy


www/varnish/vcl/pre:
  test.succeed_without_changes:
    - require:
      - user: www/varnish/varnishsecret
      - user: www/varnish/varnishdeploy
      - file: www/varnish/varnishdeploy/id_rsa
    - require_in:
      - file: www/varnish/vcl/dir
      - cmd: www/varnish/vcl/chown
      - cmd: www/varnish/vcl/dir_chmod
      - cmd: www/varnish/vcl/file_chmod
      - git: www/varnish/vcl/git
      - file: www/varnish/vcl/secret

www/varnish/vcl:
  test.succeed_without_changes:
    - require:
      - file: www/varnish/vcl/dir
      - cmd: www/varnish/vcl/chown
      - cmd: www/varnish/vcl/dir_chmod
      - cmd: www/varnish/vcl/file_chmod
      - git: www/varnish/vcl/git
      - file: www/varnish/vcl/secret
    - watch:
      - file: www/varnish/vcl/dir
      - cmd: www/varnish/vcl/chown
      - cmd: www/varnish/vcl/dir_chmod
      - cmd: www/varnish/vcl/file_chmod
      - git: www/varnish/vcl/git
      - file: www/varnish/vcl/secret



www/varnish/vcl/dir:
  cmd.run:
    - name: 'mv "{{ varnish.lookup.config_dir }}" "{{ varnish.lookup.config_dir }}.salt"'
    - creates: '{{ varnish.lookup.config_dir }}.salt'
    - onlyif: test -d {{ varnish.lookup.config_dir }}
    - require:
      - test: www/varnish/vcl/pre
  
  file.directory:
    - name: {{ varnish.lookup.config_dir }}
    - user: varnishdeploy
    - group: varnishdeploy
    - mode: 0775
    - require:
      - cmd: www/varnish/vcl/dir

www/varnish/vcl/chown:
  cmd.run:
    - name: find {{ varnish.lookup.config_dir }} \! -path "*/secret" \! -path "*/varnish.params" -print0 | xargs -0 chown varnishdeploy:varnishdeploy
    - require:
      - file: www/varnish/vcl/dir

www/varnish/vcl/dir_chmod:
  cmd.run:
    - name: find {{ varnish.lookup.config_dir }} -type d -print0 | xargs -0 chmod u=rwx,g=srwx,o=rx
    - require:
      - file: www/varnish/vcl/dir
  
www/varnish/vcl/file_chmod:
  cmd.run:
    - name: find {{ varnish.lookup.config_dir }} -type f \! -path "*/secret" \! -path "*/varnish.params" -print0 | xargs -0 -r chmod ug=rwX,o=rX
    - require:
      - file: www/varnish/vcl/dir

www/varnish/vcl/ssh_known_hosts:
  ssh_known_hosts.present:
    - name: '{{ varnish.vcl_git.sshhost }}'
    - port: 22
    - user: varnishdeploy
    - fingerprint: {{ varnish.vcl_git.sshfingerprint }}
    - key: {{ varnish.vcl_git.sshkey }}
    - enc: {{ varnish.vcl_git.sshenc }}
    - hash_hostname: False
    - hash_known_hosts: False
    - require:
      - test: www/varnish/vcl/pre

www/varnish/vcl/git:
  pkg.installed:
    - name: git
  
  git.latest:
    - name: {{ varnish.vcl_git.url }}
    - target: {{ varnish.lookup.config_dir }}
    - user: varnishdeploy
    - submodules: True
    - require:
      - file: www/varnish/vcl/dir
      - cmd: www/varnish/vcl/chown
      - cmd: www/varnish/vcl/dir_chmod
      - cmd: www/varnish/vcl/file_chmod
      - pkg: www/varnish/vcl/git
      - ssh_known_hosts: www/varnish/vcl/ssh_known_hosts

www/varnish/vcl/git/shared:
  git.config:
    - name: core.sharedRepository
    - value: group
    - user: varnishdeploy
    - repo: {{ varnish.lookup.config_dir }}
    - require:
      - git: www/varnish/vcl/git

www/varnish/vcl/secret:
  file.managed:
    - name: {{ varnish.lookup.config_dir }}/secret
    - source: {{ varnish.lookup.config_dir }}.salt/secret
    - user: root
    - group: varnishsecret
    - mode: 0640
    - require:
      - git: www/varnish/vcl/git


