#
# Cookbook Name:: haproxy
# Recipe:: default
#
# Copyright 2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
package 'haproxy' do
  action :install
end

if platform?('debian','ubuntu')
  template '/etc/default/haproxy' do
    source 'haproxy-default.erb'
    owner 'root'
    group 'root'
    mode 0644
  end
end

include_recipe 'haproxy::service'

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

template '/etc/haproxy/haproxy.cfg' do
  source 'haproxy.cfg.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, "service[haproxy]"
end

service 'haproxy' do
  action [:enable, :start]
end
