include_recipe 'nginx'

if(node[:geminabox][:ssl])
  if(node[:geminabox][:ssl] == 'databag')
    if(node[:geminabox][:ssl_databag_secret])
      if(File.exists?(node[:geminabox][:ssl_databag_secret]))
        g_secret = Chef::EncryptedDataBagItem.load_secret(node[:geminabox][:ssl_databag_secret])
      else
        g_secret = node[:geminabox][:ssl_databag_secret]
      end
      g_bag = Chef::EncryptedDataBagItem.load('geminabox', 'ssl', g_secret)
    else
      g_bag = search(:geminabox, 'id:ssl')
    end
  else
    geminabox_key = node[:geminabox][:ssl_key]
    geminabox_cert = node[:geminabox][:ssl_cert]
  end
end

if(g_bag)
  %w(key cert).each do |key|
    template File.join('/', 'etc', 'nginx', "geminabox.ssl.#{key}") do
      source 'stub.erb'
      variables(
        :content => g_bag[key]
      )
    end
  end
  geminabox_key = File.join('/', 'etc', 'nginx', 'geminabox.ssl.key')
  geminabox_cert = File.join('/', 'etc', 'nginx', 'geminabox.ssl.cert')
end

g_auth_path = File.join('/', 'etc', 'nginx', 'geminabox.htpasswd')
if(node[:geminabox][:auth_required])
  if(node[:geminabox][:auth_required] == 'databag')
    if(node[:geminabox][:auth_databag_secret])
      if(File.exists?(node[:geminabox][:auth_databag_secret]))
        g_secret = Chef::EncryptedDataBagItem.load_secret(node[:geminabox][:auth_databag_secret])
      else
        g_secret = node[:geminabox][:auth_databag_secret]
      end
      auth_bag = Chef::EncryptedDataBagItem.load('geminabox', 'auth', g_secret)
    else
      auth_bag = search(:geminabox, 'id:auth')
    end
  else
    if(File.exists?(node[:geminabox][:auth_required].to_s))
      geminabox_auth = node[:geminabox][:auth_required]
    elsif(!node[:geminabox][:auth_username].to_s.empty?)
      package "apache2-utils" do
        action :install
        not_if "ls /usr/bin/htpasswd"
      end
      execute "htpasswd" do
        command "htpasswd -c -b #{g_auth_path} #{node[:geminabox][:auth_username]} #{node[:geminabox][:auth_password]}"
        creates '/etc/nginx/geminabox.htpasswd'
        action :run
      end
      geminabox_auth = g_auth_path
    else
      raise 'Failed to determine authentication setup'
    end
  end
end

if(auth_bag)
  template g_auth_path do
    source 'stub.erb'
  end
end

if(node[:geminabox][:ssl] && (geminabox_cert.to_s.empty? || geminabox_key.to_s.empty?))
  Chef::Log.warn "SSL has been required but key/cert cannot be found"
end
if(node[:geminabox][:auth_required] && geminabox_auth.to_s.empty?)
  Chef::Log.warn "AUTH has been required but auth file cannot be found"
end

Chef::Log.info "CERT: #{geminabox_cert.inspect} - KEY: #{geminabox_key.inspect}"

template File.join('/', 'etc', 'nginx', 'sites-available', 'geminabox') do
  source 'nginx-geminabox.erb'
  variables(
    :socket => File.join(node[:geminabox][:base_directory], 'unicorn.socket'),
    :ssl => node[:geminabox][:ssl] && !geminabox_cert.to_s.empty? && !geminabox_key.to_s.empty?,
    :root => node[:geminabox][:base_directory],
    :ssl_cert => geminabox_cert,
    :ssl_key => geminabox_key,
    :auth => node[:geminabox][:auth_required] && !geminabox_auth.to_s.empty?,
    :auth_file => geminabox_auth
  )
  mode '0644'
  notifies :restart, 'service[nginx]'
end

nginx_site 'default' do
  enable false
  notifies :restart, 'service[nginx]'
end

nginx_site 'geminabox' do
  enable true
  notifies :restart, 'service[nginx]'
end
