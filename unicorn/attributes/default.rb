Chef::Log.info("Set nginx attributes")

default[:custom_nginx]                        = {}
default[:custom_nginx][:client_max_body_size] = node[:custom_nginx][:client_max_body_size] || "10"
