# Grumphp Setup

If you want to use `grumphp` in your `git hooks`, the `grumphp` commands need to be executed inside the `phpfpm` container.

This project provides 2 custom `git hook` templates for that:

* [See config/grumphp/hooks](../config/grumphp/hooks)

Copy them into your project and add this in your `composer.json`:

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
