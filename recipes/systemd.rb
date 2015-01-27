execute 'systemctl-daemon-reload' do
  command '/bin/systemctl --system daemon-reload'
  action :nothing
end

template '/usr/lib/systemd/system/geminabox.service' do
  source 'systemd-geminabox.service.erb'
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
  notifies :run, 'execute[systemctl-daemon-reload]', :immediately
  notifies :restart, 'service[geminabox]', :immediately
end

service 'geminabox' do
  provider Chef::Provider::Service::Systemd
  supports :status => true, :restart => true, :reload => true
  action [:start, :enable]
end