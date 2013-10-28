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

** Running the Resque.conf as an upstart **

```console
RAILS_ENV=production bundle exec foreman export upstart /etc/init -a opendevdata -d /var/www/opendevdata/ -u www-data -c worker=3,scheduler=1
```


Copy the sample `resque.conf` file; edit it to match your system settings


TODO: work on capistrano deployment recipe; work on fabfile for deployment through python.
