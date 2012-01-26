if(node[:geminabox][:ssl])
  if(node[:geminabox][:ssl] == :databag)
    if(node[:geminabox][:ssl_databag_secret])
      if(File.exists?(node[:geminabox][:ssl_databag_secret]))
        g_secret = Chef::EncryptedDataBagItem.load_secret(node[:geminabox][:ssl_databag_secret])
      else
        g_secret = node[:geminabox][:ssl_databag_secret]
      end
      g_bag = Chef::EncryptedDataBagItem.load('geminabox', 'ssl', secret)
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
    template File.join('/', 'etc', 'nginx', "ssl.#{key}") do
      source 'nginx-ssl-stub.erb'
      variables(
        :content => g_bag[key]
      )
    end
  end
  geminabox_key = File.join('/', 'etc', 'nginx', 'ssl.key')
  geminabox_cert = File.join('/', 'etc', 'nginx', 'ssl.cert')
end

g_auth_path = File.join('/', 'etc', 'nginx', 'geminabox.htpasswd')
if(node[:geminabox][:auth_required])
  if(node[:geminabox][:auth_required] == :databag)
    if(node[:geminabox][:auth_databag_secret])
      if(File.exists?(node[:geminabox][:auth_databag_secret]))
        g_secret = Chef::EncryptedDataBagItem.load_secret(node[:geminabox][:auth_databag_secret])
      else
        g_secret = node[:geminabox][:auth_databag_secret]
      end
      auth_bag = Chef::EncryptedDataBagItem.load('geminabox', 'auth', secret)
    else
      auth_bag = search(:geminabox, 'id:auth')
    end
  else
    if(File.exists?(node[:geminabox][:auth_required].to_s))
      geminabox_auth = node[:geminabox][:auth_required]
    elsif(!node[:geminabox][:auth_username].to_s.empty?)
      package "apache2-utils" do
        action :install
        not_if system('ls /usr/bin/htpasswd')
      end
      execute "htpasswd" do
        command "htpasswd -b #{g_auth_path} #{node[:geminabox][:auth_username]} #{node[:geminabox][:auth_password]}"
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
    source 'nginx-ssl-stub.erb'
  end
end

template File.join('/', 'etc', 'nginx', 'sites-available', 'geminabox') do
  source 'nginx-geminabox.erb'
  variables(
    :socket => File.join(node[:geminabox][:base_directory], 'unicorn.socket'),
    :ssl => node[:geminabox][:ssl],
    :root => node[:geminabox][:base_directory],
    :ssl_cert => geminabox_cert,
    :ssl_key => geminabox_key,
    :auth => node[:geminabox][:auth_required],
    :auth_file => geminabox_auth
  )
end
