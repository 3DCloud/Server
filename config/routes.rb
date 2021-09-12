# frozen_string_literal: true

Rails.application.routes.draw do
  post '/graphql', to: 'graphql#execute'

  get '/auth', to: 'temporary#index'
  post '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/:provider/logout', to: 'sessions#destroy'

  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql'
  end
end
