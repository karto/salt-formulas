
include:
  - www.uwsgi.install
  - www.uwsgi.config
  - www.uwsgi.service


extend:
  www/uwsgi/config/pre:
    test.succeed_without_changes:
      - require:
        - test: www/uwsgi/install
      - watch:
        - test: www/uwsgi/install
  
  www/uwsgi/service/pre:
    test.succeed_without_changes:
      - require:
        - test: www/uwsgi/config
      - watch:
        - test: www/uwsgi/config
