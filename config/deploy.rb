# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock '~> 3.16.0'

role :app, %w[print3dcloud@server.makerepo.com]
role :web, %w[print3dcloud@server.makerepo.com]
role :db,  %w[print3dcloud@server.makerepo.com]

set :application, 'print3dcloud'
set :repo_url, 'https://github.com/3DCloud/Server'
set :rbenv_type, :user
set :rbenv_ruby, '3.0.2'
set :keep_releases, 3
set :ejson_deploy_mode, :remote
set :default_env, { 'PASSENGER_INSTANCE_REGISTRY_DIR' => '/var/passenger_instance_registry' }
