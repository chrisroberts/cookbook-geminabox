maintainer       "Chris Roberts"
maintainer_email "chrisroberts.code@gmail.com"
license          "Apache 2.0"
description      "Installs and configures Geminabox"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.2.0"

supports 'ubuntu'

depends 'unicorn'
depends 'rc_mon'
depends 'nginx'
depends 'build-essential'

suggests 'bag_config', '>= 2.0.0'
