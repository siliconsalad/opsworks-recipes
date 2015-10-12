Chef::Log.info("Launch swf workers and cron")

node[:deploy].each do |app_name, deploy|
  Chef::Log.info("Debug : #{deploy[:application_type]}")
  Chef::Log.info("Debug : #{deploy}")

  execute "launch rake task 'workflow_worker' in background " do
    cwd deploy[:current_path]
    command "RAILS_ENV=#{deploy[:rails_env]} BACKGROUND=y bundle exec rake swf:workflow_worker"
    action :run
  end

  execute "launch rake task 'activity_worker' in background " do
    cwd deploy[:current_path]
    command "RAILS_ENV=#{deploy[:rails_env]} BACKGROUND=y bundle exec rake swf:activity_worker"
    action :run
  end

  execute "launch rake task 'cron_workflow_start' in background " do
    cwd deploy[:current_path]
    command "RAILS_ENV=#{deploy[:rails_env]} bundle exec rake swf:cron_workflow_start"
    action :run
  end

end