# Magento Setup Install Commands

Starting in Magento 2.4 Elastic Search is required:
```
dockergento magento setup:install \
  --db-host=db \
  --db-name=magento \
  --db-user=magento \
  --db-password=magento \
  --base-url=http://localhost/ \
  --admin-firstname=Chuck \
  --admin-lastname=Greenman \
  --admin-email=charlesgreenman@gmail.com \
  --admin-user=chuck \
  --backend-frontname=admin \
  --admin-password=password123 \
  --language=en_US \
  --currency=USD \
  --timezone=America/New_York \
  --use-rewrites=1 \
  --elasticsearch-host=elasticsearch \
  --elasticsearch-port=9200 \
  --elasticsearch-username=magento \
  --elasticsearch-password=magento
```

For Magento 2.3 installations and below the following will still work:
```
dockergento magento setup:install \
  --db-host=db \
  --db-name=magento \
  --db-user=magento \
  --db-password=magento \
  --base-url=http://magento2.lo/ \
  --admin-firstname=John \
  --admin-lastname=Smith \
  --admin-email=john.smith@gmail.com \
  --admin-user=john.smith \
  --backend-frontname=admin \
  --admin-password=password123 \
  --language=en_US \
  --currency=USD \
  --timezone=America/New_York \
  --use-rewrites=1
```

```
dockergento magento deploy:mode:set developer
```
