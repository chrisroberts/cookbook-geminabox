include_recipe 'build-essential'

node.default[:rbenv][:rubies] = ["#{node.geminabox.ruby.version}"]
node.default[:rbenv][:global] = node[:geminabox][:ruby][:version]

ruby_path = "#{node.rbenv.root_path}/versions/#{node.geminabox.ruby.version}"

include_recipe 'rbenv::default'
include_recipe 'rbenv::ruby_build'

# backward compatibility, should be deprecated and removed
unless node[:geminabox][:init].nil?
  Chef::Log.warn <<-EOH
node['geminbox']['init'] has been changed to node['geminbox']['monitor'] to 
match with reality. The attribute has been converted but this warning and 
conversion may be removed in the next major release of this cookbook.
EOH
  node.default[:geminabox][:monitor] = node[:geminabox][:init]    
end

# Ensure our directories exist
directory node[:geminabox][:config_directory] do
  action :create
  recursive true
  mode '0755'
end

directory File.join(node[:geminabox][:base_directory], node[:geminabox][:data_directory]) do
  action :create
  recursive true
  mode '0755'
  owner node[:geminabox][:www_user]
  group node[:geminabox][:www_group]
end

rbenv_ruby node[:geminabox][:ruby][:version]

rbenv_gem 'bundler' do
  ruby_version node[:geminabox][:ruby][:version]
end

# Install the gem
rbenv_gem 'geminabox' do
  ruby_version node[:geminabox][:ruby][:version]
  version node[:geminabox][:version] if node[:geminabox][:version]
end

# Setup the frontend
case node[:geminabox][:frontend].to_sym
when :nginx
  include_recipe 'geminabox::nginx'
else
  raise ArgumentError.new "Unknown frontend style provided: #{node[:geminabox][:frontend]}"
end

# Setup the backend
case node[:geminabox][:backend].to_sym
when :unicorn
  include_recipe 'geminabox::unicorn'
else
  raise ArgumentError.new "Unknown backend style provided: #{node[:geminabox][:backend]}"
end

# Configure geminabox
template File.join(node[:geminabox][:base_directory], 'config.ru') do
  source 'config.ru.erb'
  variables(
    :geminabox_data_directory => File.join(node[:geminabox][:base_directory], node[:geminabox][:data_directory]),
    :geminabox_build_legacy => node[:geminabox][:build_legacy],
    :geminabox_rubygems_proxy => node[:geminabox][:rubygems_proxy]
  )
  mode '0644'
  notifies :restart, 'service[geminabox]'
end

# Setup the init
include_recipe "geminabox::#{node[:geminabox][:init_type]}"

# Setup process monitor
case node[:geminabox][:monitor].to_sym
when :bluepill
  include_recipe 'geminabox::bluepill'
when :supervisord
  include_recipe 'geminabox::supervisord'
else
  raise ArgumentError.new "Unknown monitor option provided: #{node[:geminabox][:monitor]}"
end

