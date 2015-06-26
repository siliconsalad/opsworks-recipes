Chef::Log.info("Configure Nginx")

node[:deploy].each do |app_name, deploy|
  if defined?(deploy[:application_type]) && deploy[:application_type] == 'rails'
    script "add_htpasswd" do
      interpreter "bash"
      user "root"
      cwd "/"
      code <<-EOH
      apt-get install -y libcurl3 libcurl3-dev
      EOH
    end
  end
end
