Chef::Log.info("Configure Nginx")

node[:deploy].each do |app_name, deploy|
  Chef::Log.info("Debug : #{deploy[:application_type]}")
  Chef::Log.info("Debug : #{deploy}")

  if defined?(deploy[:application_type]) && deploy[:application_type] == 'static'
    Chef::Log.info("Update conf file : /etc/nginx/sites-available/#{app_name.gsub('-', '_')}")

    template "/etc/nginx/sites-available/#{app_name.gsub('-', '_')}" do
      source "site.erb"

      variables(
        :proxy_url  => deploy[:environment][:proxy_url],
        :app_name   => app_name.gsub('-', '_'),
        :domain     => (deploy[:domains].first),
        :non_first_domains => (deploy[:domains][1..-1])
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
