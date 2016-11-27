class SessionsController < ApplicationController
  def create
    session[:user] = {
      id: auth_hash[:uid],
      name: auth_hash[:info][:name]
    }
    redirect_to '/'
  end

  def destroy
    session[:user] = nil
    flash[:notice] = "Byl jste úspěšně odhlášen"
    redirect_to '/'
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
