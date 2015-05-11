Chef::Log.info("Configure Nginx")

node[:deploy].each do |app_name, deploy|
  if defined?(deploy[:application_type]) && (deploy[:application_type] == 'custom' || deploy[:application_type] == 'rails')

    script "install_elasticsearch" do
      interpreter "bash"
      user "root"
      cwd "/"
      code <<-EOH
      wget -qO - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
      add-apt-repository 'deb http://packages.elasticsearch.org/elasticsearch/1.3/debian stable main'
      apt-get update && apt-get install elasticsearch=1.3.4
      apt-get -y install default-jre
      EOH
    end

    service "elasticsearch" do
      action :stop
    end

    script "install_elasticsearch_plugin" do
      interpreter "bash"
      user "root"
      cwd "/"
      code <<-EOH
      /usr/share/elasticsearch/bin/plugin -install elasticsearch/elasticsearch-cloud-aws/2.3.0
      /usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head
      EOH
    end

    template "/etc/elasticsearch/elasticsearch.yml" do
      source "elasticsearch_master.yml.erb"

      variables(
        :elasticsearch_cluster    => node[:elasticsearch][:cluster],
        :elasticsearch_access_key => node[:elasticsearch][:access_key],
        :elasticsearch_secret_key => node[:elasticsearch][:secret_key],
        :elasticsearch_region     => node[:elasticsearch][:region]
      )
    end

    service "elasticsearch" do
      action :start
    end
  end
end
