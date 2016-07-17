
include:
  - net.kafka.install
  - net.kafka.config
  - net.kafka.service

extend:
  net/kafka/config/pre:
    test.succeed_without_changes:
      - require:
        - test: net/kafka/install
      - watch:
        - test: net/kafka/install
  
  net/kafka/service/pre:
    test.succeed_without_changes:
      - require:
        - test: net/kafka/config
      - watch:
        - test: net/kafka/config

