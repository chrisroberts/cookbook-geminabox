template '/etc/init/geminabox.conf' do
  source 'upstart-geminabox.conf.erb'
  mode '0600'
  owner 'root'
  group 'root'
  variables(
    :pid => File.join(node[:geminabox][:base_directory], 'unicorn.pid'),
    :working_directory => node[:geminabox][:base_directory],
    :exec => node[:geminabox][:unicorn][:exec],
    :config => File.join(node[:geminabox][:config_directory], 'geminabox.unicorn.app'),
    :process_user => node[:geminabox][:unicorn][:process_user],
    :process_group => node[:geminabox][:unicorn][:process_group],
    :maxmemory => node[:geminabox][:unicorn][:maxmemory],
    :maxcpu => node[:geminabox][:unicorn][:maxcpu],
    :bin_dir => node[:languages][:ruby][:bin_dir]
  )
end

template '/etc/default/geminabox' do
  source 'geminabox.sysconfig.erb'
  mode '0644'
  owner 'root'
  group 'root'
  variables(
    :pid => File.join(node[:geminabox][:base_directory], 'unicorn.pid'),
    :working_directory => node[:geminabox][:base_directory],
    :exec => node[:geminabox][:unicorn][:exec],
    :config => File.join(node[:geminabox][:config_directory], 'geminabox.unicorn.app'),
    :process_user => node[:geminabox][:unicorn][:process_user],
    :process_group => node[:geminabox][:unicorn][:process_group],
    :maxmemory => node[:geminabox][:unicorn][:maxmemory],
    :maxcpu => node[:geminabox][:unicorn][:maxcpu],
    :bin_dir => node[:languages][:ruby][:bin_dir]
  )
  notifies :stop, "service[#{geminabox_service}]", :immediately
  notifies :start, "service[#{geminabox_service}]", :immediately
end

service geminabox_service do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true, :reload => false
  action [:start]
end