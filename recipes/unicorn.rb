if(node[:geminabox][:unicorn][:install])
  gem_package 'unicorn' do
    action :install
    version node[:geminabox][:unicorn][:version] || '> 0'
  end
end

template File.join(node[:geminabox][:config_directory], 'unicorn.app') do
  source 'unicorn.app.erb'
  variables(
    :base_path => node[:geminabox][:base_directory],
    :workers => node[:geminabox][:unicorn][:workers] || 2,
    :socket => File.join(node[:geminabox][:base_directory], 'unicorn.socket'),
    :timeout => node[:geminabox][:unicorn][:timeout] || 30,
    :cow_friendly => node[:geminabox][:unicorn][:cow_friendly],
    :www_user => node[:geminabox][:www_user] || 'www-data'
  )
end
