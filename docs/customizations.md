# Customizations

## Custom images

if you want to use your custom `nginx`, `php` or `db` images just change the corresponding values in the `docker-compose` files. 

**Important:** If you cange the service names, you also need to customize the default values for these properties. See how to do it in the next point (custom properties)

## Adding more services

Besides the included services (`nginx`, `php`, `db`), you can add as many more as you want. You just need to take the following into account:

* Services must be added into `docker-compose.yml`
* Service has to be a `depends_on` of the `nginx` service, if you want it to start automatically.
* If your service uses same volumes as `php` and `nginx`, you need to add:
	* `volumes: *appvolumes` into `docker-compose.yml`
	* `volumes: *appvolumes-linux` into `docker-compose.dev.linux.yml`
	* `volumes: *appvolumes-mac` into `docker-compose.dev.mac.yml`

<details>
<summary>See example</summary>

`docker-compose.yml`

```
  #...
  nginx:
    image: modestcoders/nginx:1.13
    ports:
      - 80:8000
    volumes: *appvolumes
    depends_on:
      - phpfpm
      - mailhog

  mailhog:
	image: mailhog/mailhog:latest
	ports:
   	  - "8025:8025"
  #...
```

</details>

## Custom properties

There are some properties that can be customised if your project setup differs from default one. You can do so by adding a file in one of the following paths and setting your custom values. 

### Custom properties paths

* `<PROJECT_ROOT>/config/dockergento/properties`
* `<PROJECT_ROOT>/../config/dockergento/properties`
* `<PROJECT_ROOT>/../../config/dockergento/properties`

### Default properties

Default list of properties that can be customised:

* See [console/properties/dockergento_properties](../console/properties/dockergento_properties)

### Examples

* If you have the magento code in a subfolder called for example `magento`. 

	```
	# <PROJECT_ROOT>/config/dockergento/properties
	MAGENTO_DIR="magento"
	```
	
* if your magento version is `<=2.1`

	```
	# <PROJECT_ROOT>/config/dockergento/properties
    GENERATED_DIR="var/generation"
	```
