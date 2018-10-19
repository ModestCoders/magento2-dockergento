# Magento Setup Install Commands

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
