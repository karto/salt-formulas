{% from "www/nginx/map.jinja" import nginx with context %}
{% import 'statehelper.sls' as statehelper %}

www/nginx/config/pre:
  test.succeed_without_changes:
    - require_in:
      - file: www/nginx/config/file
      - cmd: www/nginx/config/dir
      - file: www/nginx/config/dir
      - file: www/nginx/config/html
      - file: www/nginx/config/logdir

www/nginx/config:
  test.succeed_without_changes:
    - require:
      - file: www/nginx/config/file
      - cmd: www/nginx/config/dir
      - file: www/nginx/config/dir
      - file: www/nginx/config/html
      - file: www/nginx/config/logdir
    - watch:
      - file: www/nginx/config/file
      - cmd: www/nginx/config/dir
      - file: www/nginx/config/dir
      - file: www/nginx/config/html
      - file: www/nginx/config/logdir


www/nginx/config/file:
  file.managed:
    - name: {{ nginx.lookup.config_file }}
    - source:
        {{ statehelper.statesource("www/nginx", "nginx.conf")|indent(6) }}
    - template: jinja
    - defaults:
        nginx: {{ nginx }}

www/nginx/config/dir:
  cmd.run:
    - name: 'test -d {{ nginx.lookup.config_dir }} && mv "{{ nginx.lookup.config_dir }}" "{{ nginx.lookup.config_dir }}.salt" || touch {{ nginx.lookup.config_dir }}.salt'
    - creates: {{ nginx.lookup.config_dir }}.salt

  file.recurse:
    - name: {{ nginx.lookup.config_dir }}
    - source:
        {{ statehelper.statesource("www/nginx", "conf.d")|indent(6) }}
    - clean: true
    - exclude_pat: "E@(^|/)\\._|\\.sample$"
    - makedirs: true
    - template: jinja
    - defaults:
        nginx: {{ nginx }}
    - require:
      - cmd: www/nginx/config/dir

www/nginx/config/html:
  file.recurse:
    - name: {{ nginx.lookup.html_dir }}
    - source:
        {{ statehelper.statesource("www/nginx", "html")|indent(6) }}
    - clean: true
    - exclude_pat: "E@(^|/)\\._|\\.sample$"
    - keep_symlinks: true
    - include_empty: true
    - makedirs: true
    - template: jinja
    - defaults:
        nginx: {{ nginx }}

www/nginx/config/logdir:
  file.directory:
    - name: /var/log/nginx
    - mode: 0755
    - user: www
    - group: www
