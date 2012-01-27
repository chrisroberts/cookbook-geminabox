node[:geminabox] = Mash.new
node[:geminabox][:version] = '~> 0.5.1'
# app configs
node[:geminabox][:config_directory] = '/etc/geminabox'
node[:geminabox][:base_directory] = '/var/www/geminabox'
node[:geminabox][:data_directory] = 'data' # This values is joined to base_directory
node[:geminabox][:build_legacy] = false
# auth configs
node[:geminabox][:auth_required] = false # Set to :databag to retreive from databag
node[:geminabox][:auth_password] = ''
node[:geminabox][:auth_username] = ''
node[:geminabox][:auth_databag_id] = 'auth' # Override this in cases where multiple geminabox instances may be running
node[:geminabox][:auth_databag_secret] = nil # Path to secret file on node or string secret
# sys configs
node[:geminabox][:www_user] = 'www-data'
# ssl configs
node[:geminabox][:ssl] = false # Set to :databag to retreive from databag
node[:geminabox][:ssl_key] = '' # Path to key on node
node[:geminabox][:ssl_cert] = '' # Path to cert on node
node[:geminabox][:databag_id] = 'ssl' # Override this in cases where multiple geminabox instances may be running
node[:geminabox][:ssl_databag_secret] = nil # Path to secret file on node or string secret
# unicorn configs
node[:geminabox][:unicorn] = Mash.new
node[:geminabox][:unicorn][:install] = false
node[:geminabox][:unicorn][:version] = '> 0'
node[:geminabox][:unicorn][:cow_friendly] = true
node[:geminabox][:unicorn][:timeout] = 30
node[:geminabox][:unicorn][:workers] = 2
node[:geminabox][:unicorn][:process_user] = node[:geminabox][:www_user]
node[:geminabox][:unicorn][:process_group] = node[:geminabox][:www_user]
node[:geminabox][:unicorn][:maxmemory] = 50
node[:geminabox][:unicorn][:maxcpu] = 20
node[:geminabox][:unicorn][:exec] = '/usr/local/bin/unicorn'
# nginx configs
node[:geminabox][:nginx] = Mash.new
# bluepill configs
node[:geminabox][:bluepill] = Mash.new
