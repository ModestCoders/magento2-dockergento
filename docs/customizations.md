# Customizations

## Custom images

if you want to use your custom `php`, `db` or `nginx` images just change the corresponding values in the `docker-compose` files. 

**Important:** If you cange the service names, you also need to customize the default values for these properties. See how to do it in the next point (custom properties)

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
