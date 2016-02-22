# Magento app for Payfort Start

# Credentials

login: demo
password: demo123

# Configuration

Use host ip address as magento host during configuration. Later connect to docker
container (named app) and run:

```
# docker exec -t -i app /bin/bash
# mysql -u root -p
mysql> use demo;
mysql> update core_config_data set value="http://app/" where config_id=9;
mysql> update core_config_data set value="http://app/" where config_id=10;
mysql> exit;
```
