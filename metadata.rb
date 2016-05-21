name             'geminabox'
maintainer       'Chris Roberts'
maintainer_email 'chrisroberts.code@gmail.com'
license          'Apache 2.0'
description      'Installs and configures Geminabox'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.3.0'

issues_url 'https://github.com/chrisroberts/cookbook-geminabox/issues' if respond_to?(:issues_url)
source_url 'https://github.com/chrisroberts/cookbook-geminabox.git' if respond_to?(:source_url)

depends 'unicorn'
depends 'rc_mon'
depends 'bluepill'
depends 'nginx', '>= 2.7.6'
depends 'build-essential'
depends 'ssl_certificate'
