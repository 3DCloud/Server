# frozen_string_literal: true

Rails.application.routes.draw do
  post '/graphql', to: 'graphql#execute'

  get '/authorize', to: 'sessions#new'
  post '/sessions/callback', to: 'sessions#create'
  post '/sessions/token', to: 'sessions#token'
  post '/logout', to: 'sessions#destroy'

  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql'
  end
end
