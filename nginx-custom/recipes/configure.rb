Chef::Log.info("Configure Nginx")

node[:deploy].each do |app_name, deploy|
  if defined?(deploy[:application_type]) && deploy[:application_type] == 'rails'
    Chef::Log.info("Update conf file : /etc/nginx/sites-available/#{app_name.gsub('-', '_')}")

    template "/etc/nginx/sites-available/#{app_name.gsub('-', '_')}" do
      source "site.erb"

      variables(
        :app_name             => app_name.gsub('-', '_'),
        :domain               => (deploy[:domains].first),
        :client_max_body_size => node[:custom_nginx][:client_max_body_size]
      )
    end

    service "nginx" do
      action :reload
    end

    service "nginx" do
      action :restart
    end
  end
end
