node[:deploy].each do |app_name, deploy|
  Chef::Log.info("Upgrade HAProxy")


  script "upgrade_haproxy" do
    interpreter "bash"
    user "root"
    cwd "/home/ubuntu/"
    code <<-EOH
      echo deb http://archive.ubuntu.com/ubuntu trusty-backports main universe | \
      sudo tee /etc/apt/sources.list.d/backports.list
      apt-get update -y
      apt-get install -o Dpkg::Options::="--force-confold" --force-yes -y haproxy -t trusty-backports
    EOH
  end
end
