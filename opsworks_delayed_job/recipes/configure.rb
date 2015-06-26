# Adapted from rails::configure: https://github.com/aws/opsworks-cookbooks/blob/master/rails/recipes/configure.rb

include_recipe "deploy"
include_recipe "opsworks_delayed_job::service"

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

end
