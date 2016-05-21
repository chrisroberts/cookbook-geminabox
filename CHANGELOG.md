## v0.3.0
* use berkshelf for cookbook dependency resolution
* pin nginx cookbook to <= 2.7.5
* add rakefile and rubocop.yml
* update kitchen to use centos 6.7
* fix cops
* set ssl_protocol default to TLSv1

## v0.2.0
* SSL support updates
* Remove default version restriction

## v0.1.2
* HTTPS fixes: https://github.com/chrisroberts/cookbook-geminabox/pull/4

## v0.1.1
* Fix bluepill commands (thanks [Andrew Wason](https://github.com/rectalogic))
* Disambiguate ssl enabled flag (thanks https://github.com/jblatt-verticloud)
* Remove extra double quote from unix domain socket in unicorn config file (thanks https://github.com/jblatt-verticloud)
