Chef::Log.info("Set nginx attributes")

authorized_ip = node[:custom_nginx][:authorized_ip] || '10.0.0.0/8'
default[:nginx_custom_ip] = {}
default[:nginx_custom_ip][:authorized_ip] = authorized_ip
