# Grumphp Setup

If you want to use `grumphp` together with `git hooks`, the `grumphp` commands need to be executed inside the `phpfpm` container. To configure that, do the following:

#### 1. Custom Grumphp hook templates

Copy provided `grumphp` templates into your project 

* See [config/grumphp/hooks](../config/grumphp/hooks)

```
cp magento2-dockergento/config/grumphp/hooks <your_project>/config/grumphp/hooks
```

#### 2. Overwrite default ones

Add this in your `composer.json`:

```
"scripts": {
    "grumphpTemplates": "cp -Rf config/grumphp/hooks/* vendor/phpro/grumphp/resources/hooks/local/",
    "pre-autoload-dump": [
        "cp vendor/magento/magento2-base/app/etc/NonComposerComponentRegistration.php app/etc/NonComposerComponentRegistration.php"
    ],
    "post-install-cmd": [
        "@grumphpTemplates"
    ],
    "post-update-cmd": [
        "@grumphpTemplates"
    ]
}
```
