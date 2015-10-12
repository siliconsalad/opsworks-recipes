Chef::Log.info("Install wkhtmltopdf")

node[:deploy].each do |app_name, deploy|

  remote_file '/usr/local/bin/wkhtmltox-0.12.2.1_linux-centos6-amd64.rpm' do
    source 'http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-centos6-amd64.rpm'
    mode '755'
  end

  package "install xorg-x11-fonts-75dpi" do
    package_name "xorg-x11-fonts-75dpi"
  end

  execute "install wkhtmltox-0.12.2.1_linux-centos6-amd64.rpm" do
    command "rpm -ivh wkhtmltox-0.12.2.1_linux-centos6-amd64.rpm"
    action :run
  end

  execute "rename wkhtmltopdf to wkhtmltopdf_bin" do
    command "mv /usr/local/bin/wkhtmltopdf /usr/local/bin/wkhtmltopdf_bin"
  end

  package "install xorg-x11-server-Xvfb" do
    package_name "xorg-x11-server-Xvfb" 
  end

  file '/usr/local/bin/wkhtmltopdf.sh' do
    content 'xvfb-run --server-args="-screen 0, 1024x768x24" /usr/local/bin/wkhtmltopdf_bin $*'
    mode '755'
  end

  execute 'link custom script in /usr/local/bin' do
    command "ln -s /usr/local/bin/wkhtmltopdf.sh /usr/local/bin/wkhtmltopdf"
    action :run
  end

end



  # package "install wkhtmltopdf" do
  #   package_name 'wkhtmltopdf'
  # end

  # package "install xvfb" do
  #   package_name 'xvfb'
  # end

  # file '/usr/local/bin/wkhtmltopdf.sh' do
  #   content 'xvfb-run --server-args="-screen 0, 1024x768x24" /usr/bin/wkhtmltopdf $*'
  # end

  # execute "make executable wkhtmltopdf.sh" do
  #   command "chmod a+rx /usr/local/bin/wkhtmltopdf.sh"
  #   action :run
  # end

  # execute "link custom script in /usr/local/bin/" do
  #   command "ln -s /usr/local/bin/wkhtmltopdf.sh /usr/local/bin/wkhtmltopdf"
  #   action :run
  # end