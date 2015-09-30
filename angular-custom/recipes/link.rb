node[:deploy].each do |application, deploy|
  Chef::Log.info("Debug : #{deploy[:application_type]}")
  Chef::Log.info("Debug : #{deploy}")

  if defined?(deploy[:application_type]) && deploy[:application_type] == 'static'
    env          = node[:angular][:env]
    current_path = deploy[:current_path]

    Chef::Log.info("Symlink files")
    Chef::Log.info("Env : #{env}")

    Chef::Log.info("Path rootScope : #{current_path}/app/js/rootScope/rootScope.#{env}.html")

    script 'symlink_rootScope_file' do
      interpreter "bash"
      cwd "#{current_path}/app/js/rootScope/"
      user "root"
      code <<-EOH
        if [ -f rootScope.#{env}.js ]; then
        ln -sf rootScope.#{env}.js rootScope.js
        fi
      EOH
    end

    Chef::Log.info("Path index.html : #{current_path}/app/index.#{env}.html")

    script 'symlink_index' do
      interpreter "bash"
      cwd "#{current_path}/app/"
      user "root"
      code <<-EOH
        if [ -f index.#{env}.html ]; then
        ln -sf index.#{env}.html index.html
        fi
      EOH
    end

    Chef::Log.info("Path robots.txt : #{current_path}/app/robots.#{env}.html")

    script 'symlink_robots' do
      interpreter "bash"
      cwd "#{current_path}/app/"
      user "root"
      code <<-EOH
        if [ -f robots.#{env}.txt ]; then
        ln -sf robots.#{env}.txt robots.txt
        fi
      EOH
    end
  end
end
