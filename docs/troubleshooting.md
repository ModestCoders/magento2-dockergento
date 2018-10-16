# Troubleshooting

## Unison watch not working

#### Problem

`dockergento watch` seems to do nothing

#### Reason 

Sometimes the unison watcher might not work due to problems with `inotify` in Docker.

#### Solution

Restart the docker daemon and try it again.

```
dockergento watch <magento_dir>/vendor/<vendor_name>/<module_name> 
```
