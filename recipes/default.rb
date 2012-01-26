# Setup the frontend
if(node[:geminabox][:nginx] || :this_is_all_we_support_now)
  include_recipe 'geminabox::nginx'
end

# Install the gem
gem_package('geminabox') do
  action :install
  version node[:geminabox][:version] || '~> 0.5.1'
end

# Configure up server instance
if(node[:geminabox][:unicorn] || :this_is_all_we_support)
  include_recipe 'geminabox::unicorn'
end

# Load up the monitoring
if(node[:geminabox][:bluepill] || :this_is_all_we_support)
  include_recipe 'geminabox::bluepill'
end

template File.join(node[:geminabox][:config_directory], 'config.ru') do
  source 'config.ru.erb'
  variables(
    :geminabox_data_directory => File.join(node[:geminabox][:base_directory], node[:geminabox][:data_directory])
  )
end
