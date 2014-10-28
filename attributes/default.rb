default[:geminabox] = Mash.new
default[:geminabox][:version] = '~> 0.6'
# setup configs
default[:geminabox][:frontend] = 'nginx'
default[:geminabox][:backend] = 'unicorn'
default[:geminabox][:init] = 'bluepill'
# app configs
default[:geminabox][:config_directory] = '/etc/geminabox'
default[:geminabox][:base_directory] = '/var/www/geminabox'
default[:geminabox][:data_directory] = 'data' # This values is joined to base_directory
default[:geminabox][:build_legacy] = false
# auth configs
default[:geminabox][:auth_required] = false
# sys configs
default[:geminabox][:www_user] = 'www-data'
# ssl configs
default[:geminabox][:ssl][:enabled] = false
default[:geminabox][:ssl][:snakeoil] = true
# unicorn configs
default[:geminabox][:unicorn] = Mash.new
default[:geminabox][:unicorn][:install] = false
default[:geminabox][:unicorn][:version] = '> 0'
default[:geminabox][:unicorn][:cow_friendly] = true
default[:geminabox][:unicorn][:timeout] = 30
default[:geminabox][:unicorn][:workers] = 2
default[:geminabox][:unicorn][:process_user] = default[:geminabox][:www_user]
default[:geminabox][:unicorn][:process_group] = default[:geminabox][:www_user]
default[:geminabox][:unicorn][:maxmemory] = 50
default[:geminabox][:unicorn][:maxcpu] = 20
default[:geminabox][:unicorn][:exec] = '/usr/bin/unicorn'
# nginx configs
default[:geminabox][:nginx][:bind] = node.ipaddress
default[:geminabox][:nginx][:port] = 80
default[:geminabox][:nginx][:ssl_port] = 443
default[:geminabox][:nginx][:client_max_body_size] = '5M'
# bluepill configs
default[:geminabox][:bluepill] = Mash.new
