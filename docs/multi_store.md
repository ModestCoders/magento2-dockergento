# Multi Store

If you have a multi-store magento, you need to add your website codes to the ngnix configuration as follows:

1. Edit `config/dockergento/nginx/conf/default.conf`
	
```
# WEBSITES MAPPING
map $http_host $MAGE_RUN_CODE {

	default    base;
	## For multi-store configuration add here your domain-website codes
	dominio-es.lo    es;
	dominio-ch.lo    ch;
	dominio-de.lo    de;
}
```
	
2. You need to restart dockergento to apply the new configuration:
	
```
dockergento restart
```