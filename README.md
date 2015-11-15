TODO:scope APIdocs

# OpenDev Data Suite

## Dependencies
The open dev data stack has several dependencies

Application Dependencies:

* Rails
* several gems that can be found in the Gemfile

External services:

* mongodb
* e2j (python web services to convert excel to json)
* postgresql (currently e2j runs well on postgresql; as of this writing date, no persistence is present.)
* Fontawesome icons
* redis

## Installation and Development Deployment

This application can be installed on a UNIX-based system. It has been tested on
Ubuntu and Mac OS X.

* Clone the repository
* run `bundle install`
* run redis-server; on Mac, `redis-server /usr/local/etc/redis.conf`. On a linux box, this is usually an upstart script.
* Run sidekiq: `bin/sidekiq -C config/sidekiq.yml`


## Production Deployment on Ubuntu 13.10

### Deployment the hardway

#### Running sidekiq as an init.d script

There are several ways to run sidekiq. However, we'll show you the init.d way.

Copy the sidekiq script (bash) to your `/etc/init.d/` folder

```console
cp /path/to/opendevdata/confs/init.d/sidekiq /etc/init.d/
```

Change the permissions of the file (do this as root)

```console
sudo chmod 755 /etc/init.d/sidekiq
```

Start the `sidekiq` script

```console
sudo /etc/init.d/sidekiq start
```

To stop sidekiq

```console
sudo /etc/init.d/sidekiq stop
```

**Note** There are some system settings to define in this sidekiq script;
please check to make sure that this conforms to how your system appears.

TODO: work on capistrano deployment recipe; work on fabfile for deployment through python.


### Interacting with the API

Example

```console
curl -H 'Accept: application/vnd.opendevdata.v1' http://api.opendevdata.dev/open_workspaces/53a7350073636934c2070000/joined_up_datasets/548acfa36c6f63044c2b0000
```
