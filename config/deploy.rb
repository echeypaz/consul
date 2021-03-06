# config valid only for current version of Capistrano
lock '~> 3.10.1'

def deploysecret(key)
  @deploy_secrets_yml ||= YAML.load_file('config/deploy-secrets.yml')[fetch(:stage).to_s]
  @deploy_secrets_yml.fetch(key.to_s, 'undefined')
end

set :rails_env, fetch(:stage)
set :rvm1_ruby_version, '2.3.2'

set :application, 'consul'
set :full_app_name, deploysecret(:full_app_name)

set :server_name, deploysecret(:server_name)
set :repo_url, 'https://github.com/aplicacionesCabildoGranCanaria/consul.git'
>>>>>>> upstream/master

set :revision, `git rev-parse --short #{fetch(:branch)}`.strip

set :log_level, :info
set :pty, true
set :use_sudo, true

set :linked_files, %w{config/database.yml config/secrets.yml}
set :linked_dirs, %w{log tmp public/system public/assets}

set :keep_releases, 5

set :local_user, ENV['USER']

set :delayed_job_workers, 2
set :delayed_job_roles, :background

set(:config_files, %w(
  log_rotation
  database.yml
  secrets.yml
  unicorn.rb
))

<<<<<<< HEAD
set :symlinks, []

set :whenever_roles, -> { :cron }
=======
set :whenever_roles, -> { :app }
>>>>>>> upstream/master

namespace :deploy do
  before :starting, 'rvm1:install:rvm'  # install/update RVM
  before :starting, 'rvm1:install:ruby' # install Ruby and create gemset
  #before :starting, 'install_bundler_gem' # install bundler gem

  after :publishing, 'deploy:restart'
  after :published, 'delayed_job:restart'
  after :published, 'refresh_sitemap'

  after :finishing, 'deploy:cleanup'
  # Restart unicorn
  # after 'deploy:publishing', 'deploy:restart'
  after :publishing, 'restart_tmp'
  # Restart Delayed Jobs
  after 'deploy:published', 'delayed_job:restart'
end

# task :install_bundler_gem do
#   on roles(:app) do
#     execute "rvm use #{fetch(:rvm1_ruby_version)}; gem install bundler"
#   end
# end
#
# task :refresh_sitemap do
#   on roles(:app) do
#     within release_path do
#       with rails_env: fetch(:rails_env) do
#         execute :rake, 'sitemap:refresh:no_ping'
#       end
#     end
#   end
# end

desc "Restart application"
  task :restart_tmp do
    on roles(:app) do
    execute "touch #{ File.join(current_path, 'tmp', 'restart.txt') }"
  end
end

