# OpenDev Data Suite

## Dependencies
The open dev data stack has several dependencies

Application Dependecies:

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
* Run a resque worker: `rake resque:work QUEUE="*"`


## Production Deployment on Ubuntu 13.10

### Deployment the hardway

#### Running the Resque.conf as an upstart

Copy the sample `resque.conf` file; edit it to match your system settings

```console
RAILS_ENV=production bundle exec foreman export upstart /etc/init -a opendevdata -d /var/www/opendevdata/ -u www-data -c worker=3,scheduler=1
```

**Note: rbenv users might have to install https://github.com/dcarley/rbenv-sudo and follow instructions here: https://github.com/sstephenson/rbenv/issues/350
... that should return the following output

```console
eduler=1
[foreman export] writing: opendevdata.conf
[foreman export] writing: opendevdata-worker.conf
[foreman export] writing: opendevdata-worker-1.conf
[foreman export] writing: opendevdata-worker-2.conf
[foreman export] writing: opendevdata-worker-3.conf
[foreman export] writing: opendevdata-scheduler.conf
[foreman export] writing: opendevdata-scheduler-1.conf
```

You can now start or stop your opendevdata resque tasks as follows:

```console
sudo service opendevdata stop
sudo service opendevdata start
```

TODO: work on capistrano deployment recipe; work on fabfile for deployment through python.
