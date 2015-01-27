template '/etc/init.d/geminabox' do
  source 'sysv-geminabox.erb'
  mode '0755'
  owner 'root'
  group 'root'
  variables(
    :pid => File.join(node[:geminabox][:base_directory], 'unicorn.pid'),
    :working_directory => node[:geminabox][:base_directory],
    :exec => node[:geminabox][:unicorn][:exec],
    :config => File.join(node[:geminabox][:config_directory], 'geminabox.unicorn.app'),
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
  notifies :restart, 'service[geminabox]', :immediately
end

service 'geminabox' do
  supports :status => true, :restart => true, :reload => false
  action [:start, :enable]
end