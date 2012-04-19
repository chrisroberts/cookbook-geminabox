if(node[:geminabox][:unicorn][:install])
  gem_package 'unicorn' do
    action :install
    version node[:geminabox][:unicorn][:version] || '> 0'
  end
end

unicorn_config File.join(node[:geminabox][:config_directory], 'geminabox.unicorn.app') do
  listen File.join(node[:geminabox][:unicorn][:base_directory], 'unicorn.socket')
  worker_processes node[:geminabox][:unicorn][:workers] || 2
  worker_timeout node[:geminabox][:unicorn][:timeout] || 30
  working_directory node[:geminabox][:base_directory]
  preload_app true
  owner node[:geminabox][:www_user] || 'www-data'
  group node[:geminabox][:www_user] || 'www-data'
  mode '0644'
  notifies 'service[geminabox]'
end

