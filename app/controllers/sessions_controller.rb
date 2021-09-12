# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    user = User.get_or_create_from_omniauth_hash(auth_object)
    session[:user_id] = user.id
    redirect_to '/'
  end

  def destroy
    session.delete :user_id
    redirect_to '/'
  end

  protected
    def auth_object
      request.env['omniauth.auth']
    end
end
