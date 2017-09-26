# config valid only for current version of Capistrano
# lock '3.4.0'

set :application, 'homie'
set :repo_url, 'git@github.com:Chucheen/hoypormx.git'

# Default branch is :master
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/export/hoypormx'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, false

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/secrets.yml')
set :linked_dirs, %w(log tmp/pids bundle public/assets)

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# set :sidekiq_config, "#{current_path}/config/sidekiq.yml"

# after 'deploy:symlink:linked_dirs', 'bundler:install:if_changed'
# after 'deploy:updated', 'deploy:compile_assets'
# after 'deploy:updated', 'deploy:cleanup_assets'
# after 'deploy:updated', 'deploy:normalize_assets'
# after 'deploy:reverted', 'deploy:rollback_assets'
after 'deploy:updated', 'deploy:assets:precompile:if_changed'
