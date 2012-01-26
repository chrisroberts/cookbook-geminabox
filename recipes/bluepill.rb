include_recipe "bluepill"

gem_package('red_unicorn') do
  action :install
end

template '/etc/bluepill/geminabox.pill' do
  source 'bluepill-geminabox.pill.erb'
  variables(
    :pid => ,
    :working_directory => node[:geminabox][:base_directory],
    :exec => node[:geminabox][:unicorn][:exec],
    :config => File.join(node[:geminabox][:config_directory], 'unicorn.app'),
    :process_user => node[:geminabox][:unicorn][:process_user],
    :process_group => node[:geminabox][:unicorn][:process_group],
    :maxmemory => node[:geminabox][:unicorn][:maxmemory],
    :maxcpu => node[:geminabox][:unicorn][:maxcpu]
  )
end
