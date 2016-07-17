include:
  - textproc.kibana.install
  - textproc.kibana.config
  - textproc.kibana.service



extend:
  textproc/kibana/config/pre:
    test.succeed_without_changes:
      - require:
        - test: textproc/kibana/install
      - watch:
        - test: textproc/kibana/install
  
  textproc/kibana/service/pre:
    test.succeed_without_changes:
      - require:
        - test: textproc/kibana/config
      - watch:
        - test: textproc/kibana/config
