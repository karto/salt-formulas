include:
  - www.grafana.install
  - www.grafana.config
  - www.grafana.service



extend:
  www/grafana/config/pre:
    test.succeed_without_changes:
      - require:
        - test: www/grafana/install
      - watch:
        - test: www/grafana/install
  
  www/grafana/service/pre:
    test.succeed_without_changes:
      - require:
        - test: www/grafana/config
      - watch:
        - test: www/grafana/config
