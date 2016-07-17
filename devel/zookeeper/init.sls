
include:
  - devel.zookeeper.install
  - devel.zookeeper.config
  - devel.zookeeper.service


extend:
  devel/zookeeper/config/pre:
    test.succeed_without_changes:
      - require:
        - test: devel/zookeeper/install
      - watch:
        - test: devel/zookeeper/install
  
  devel/zookeeper/service/pre:
    test.succeed_without_changes:
      - require:
        - test: devel/zookeeper/config
      - watch:
        - test: devel/zookeeper/config
