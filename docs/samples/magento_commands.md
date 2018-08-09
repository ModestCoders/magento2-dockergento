# Magento Commands

## Magento Setup

```
bin/magento setup:install \
  --db-host=db \
  --db-name=magento \
  --db-user=magento \
  --db-password=magento \
  --base-url=http://<your-domain>/ \
  --admin-firstname=John \
  --admin-lastname=Smith \
  --admin-email=john.smith@gmail.com \
  --admin-user=john.smith \
  --backend-frontname=admin
  --admin-password=password123 \
  --language=en_US \
  --currency=USD \
  --timezone=America/New_York \
  --use-rewrites=1
```

## Developer mode

```
bin/magento deploy:mode:set developer
```

## Purge all

```
rm -rf var/cache/* generated/* pub/static/* var/view_preprocessed/* var/page_cache/* var/di/*
```