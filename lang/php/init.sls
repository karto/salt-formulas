
include:
  - lang.php.install
  - lang.php.config



extend:
  lang/php/config/pre:
    test.succeed_without_changes:
      - require:
        - test: lang/php/install
      - watch:
        - test: lang/php/install
  
