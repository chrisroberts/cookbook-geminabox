rbenv_gem "i18n" do
  ruby_version node[:geminabox][:ruby][:version]
  action :install
end

rbenv_gem "bluepill" do
  ruby_version node[:geminabox][:ruby][:version]
  version node[:geminabox][:bluepill][:version] if node[:geminabox][:bluepill][:version]
  action :install
end

[ 
  node[:geminabox][:bluepill][:conf_dir], 
  node[:geminabox][:bluepill][:pid_dir], 
  node[:geminabox][:bluepill][:state_dir]
].each do |dir|
  directory dir do
    recursive true
    owner "root"
    group node[:geminabox][:bluepill][:group]
  end
end

#file "#{node['geminabox']['bluepill']['logfile']}" do
file node[:geminabox][:bluepill][:logfile] do
  owner "root"
  group node[:geminabox][:bluepill][:group]
  mode "0755"
  action :create_if_missing
end

rbenv_gem 'red_unicorn' do
  ruby_version node[:geminabox][:ruby][:version]
  action :install
end

template '/etc/init/gembox-bluepill.conf' do
  source 'upstart-geminabox-bluepill.erb'
  variables(
    :www_user => node[:geminabox][:www_user],
    :base_directory => node[:geminabox][:base_directory]
  )
  notifies :restart, 'service[geminabox]'
end

template '/etc/bluepill/geminabox.pill' do
  source 'bluepill-geminabox.pill.erb'
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
  notifies :restart, 'service[geminabox]'
end


