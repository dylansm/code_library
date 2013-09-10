namespace "setup" do
  desc "Setup default BackboneJS directories (for new projects)"
  namespace :backbone do

    templates = "#{Rails.root}/app/assets/templates"
    directory "#{templates}"

    models = "#{Rails.root}/app/assets/javascripts/models"
    directory "#{models}"

    collections = "#{Rails.root}/app/assets/javascripts/collections"
    directory "#{collections}"

    views = "#{Rails.root}/app/assets/javascripts/views"
    directory "#{views}"

    routers = "#{Rails.root}/app/assets/javascripts/routers"
    directory "#{routers}"

    task :dirs => [templates, models, collections, views, routers] do
      `touch #{templates}/.gitkeep`
      `touch #{models}/.gitkeep`
      `touch #{collections}/.gitkeep`
      `touch #{views}/.gitkeep`
      `touch #{routers}/.gitkeep`
    end
  end


  task :db_file => ['config/database.yml'] do
  end

  task :api_keys_file => ['config/api_keys.yml'] do
  end

  desc "Set up Rails app for new user"
  task :project => ['setup:api_keys_file', 'setup:db_file', 'db:restore'] do
  end

  namespace :api_keys_file do
    file "config/api_keys.yml" => ['config/database.yml.template'] do
      cp "config/api_keys.yml.template", "config/api_keys.yml"
    end
  end

  namespace :db_file do
    file "config/database.yml" => ['config/database.yml.template'] do
      cp "config/database.yml.template", "config/database.yml"
    end
  end

  desc "Set up test directories if not present"
  namespace :spec do
    controllers = "#{Rails.root}/spec/controllers"
    directory "#{controllers}"

    features = "#{Rails.root}/spec/features"
    directory "#{features}"

    fixtures = "#{Rails.root}/spec/fixtures"
    directory "#{fixtures}"

    helpers = "#{Rails.root}/spec/helpers"
    directory "#{helpers}"

    requests = "#{Rails.root}/spec/requests"
    directory "#{requests}"

    routing = "#{Rails.root}/spec/routing"
    directory "#{routing}"

    support = "#{Rails.root}/spec/support"
    directory "#{support}"

    views = "#{Rails.root}/spec/views"
    directory "#{views}"

    task :dirs => [controllers, features, fixtures, helpers, requests, routing, support, views] do
      `touch #{controllers}/.gitkeep`
      `touch #{features}/.gitkeep`
      `touch #{fixtures}/.gitkeep`
      `touch #{helpers}/.gitkeep`
      `touch #{requests}/.gitkeep`
      `touch #{routing}/.gitkeep`
      `touch #{support}/.gitkeep`
      `touch #{views}/.gitkeep`
    end
  end
  

  desc "Add config/app_config file"
  task :config do
    require 'yaml'

    config_file = "#{Rails.root}/config/app_config.yml"
    `touch #{config_file}`

    puts "\nApplication Name?"
    name = $stdin.gets.chomp

    yaml_file = YAML.load(File.open("#{config_file}"))

    if yaml_file
      yaml_file['name'] = name
      yaml = yaml_file.to_yaml
    else
      yaml = { :name => "#{name}"}.to_yaml
    end

    File.open("#{config_file}", "w") {|f| f.write(yaml) }
  end


  desc "Setup puma directories"
  namespace :puma_dirs do
    puma = "#{Rails.root}/tmp/puma"
    directory "#{puma}"

    pid = "#{Rails.root}/tmp/puma/pid"
    directory "#{pid}"

    state = "#{Rails.root}/tmp/puma/state"
    directory "#{state}"

    socket = "#{Rails.root}/tmp/puma/socket"
    directory "#{socket}"

    task :create => [pid, socket, state] do
      `touch #{pid}/.gitkeep`
      `touch #{socket}/.gitkeep`
      `touch #{state}/.gitkeep`
    end
  end

  desc "Setup puma.rb"
  task :puma_config do
    `touch #{Rails.root}/config/puma.rb`
    
    puma_txt = <<-eop

# Autogenerated by rake task setup[:puma]
#
# Uncomment and update app names below

#env_apps_map = {
#  staging: 'staging-students.adoberep.com',
#  production: 'adoberep.com'
#}
#app_name = env_apps_map[Rails.env.to_sym]
#
#threads 4,4
#
#bind  "unix:///home/deploy/apps/#{app_name}/current/tmp/puma/socket/#{env}-puma.sock"
#pidfile "/home/deploy/apps/#{app_name}/current/tmp/puma/pid/#{env}.pid"
#state_path "/home/deploy/apps/#{app_name}/current/tmp/puma/state/#{env}.state"
#
#activate_control_app
    eop

    File.open("#{Rails.root}/config/puma.rb", 'w+') {|f| f.write(puma_txt) }
  end

  task :puma => ['puma_dirs:create', 'puma_config'] do
  end

end
