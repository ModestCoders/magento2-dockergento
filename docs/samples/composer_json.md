# Composer Json Example

```
{
  "name": "modestcoders/magento2-minimum-composer",
  "description": "Magento 2 minimum composer file",
  "type": "project",
  "license": [
    "proprietary"
  ],
  "authors": [
    {
      "name": "Juan Alonso",
      "email": "juan.jalogut@gmail.com"
    }
  ],
  "config": {
    "use-include-path": true,
    "preferred-install": {
      "*": "dist"
    }
  },
  "repositories": [
    {"type": "composer", "url": "https://repo.magento.com/"}
  ],
  "require": {
    "n98/magerun2": "^1.4",
    "magento/product-community-edition": "2.2.6",
    "composer/composer": "@alpha",
    "cweagans/composer-patches": "^1.6"
  },
  "require-dev": {
    "phpunit/phpunit": "~6.2.0"
  },
  "replace": {
    "magento/module-admin-notification": "*",
    "magento/module-dhl": "*",
    "magento/module-fedex": "*",
    "magento/module-marketplace": "*",
    "magento/module-multishipping": "*",
    "magento/module-persistent": "*",
    "magento/module-authorizenet": "*",
    "magento/module-google-adwords": "*",
    "magento/module-sample-data": "*",
    "dotmailer/dotmailer-magento2-extension": "*",
    "magento/module-send-friend": "*",
    "magento/module-swagger": "*",
    "magento/module-swatches-layered-navigation": "*",
    "magento/module-tax-import-export": "*",
    "magento/module-ups": "*",
    "magento/module-usps": "*",
    "magento/module-braintree": "*",
    "magento/module-webapi-security": "*",
    "magento/module-weee": "*",
    "magento/module-catalog-widget": "*",
    "magento/module-version": "*",
    "magento/module-release-notification": "*",
    "vertex/module-tax": "*",
    "klarna/module-core": "*",
    "klarna/module-ordermanagement": "*",
    "klarna/module-kp": "*",
    "temando/module-shipping-m2": "*"
  },
  "extra": {
    "magento-force": "override"
  },
  "autoload": {
    "psr-4": {
      "Magento\\Setup\\": "setup/src/Magento/Setup/"
    },
    "psr-0": {
      "": "app/code/"
    },
    "files": [
      "app/etc/NonComposerComponentRegistration.php"
    ]
  },
  "autoload-dev": {
    "psr-4": {
      "Magento\\Sniffs\\": "dev/tests/static/framework/Magento/Sniffs/",
      "Magento\\Tools\\": "dev/tools/Magento/Tools/",
      "Magento\\Tools\\Sanity\\": "dev/build/publication/sanity/Magento/Tools/Sanity/",
      "Magento\\TestFramework\\Inspection\\": "dev/tests/static/framework/Magento/TestFramework/Inspection/",
      "Magento\\TestFramework\\Utility\\": "dev/tests/static/framework/Magento/TestFramework/Utility/"
    }
  }
}
```
