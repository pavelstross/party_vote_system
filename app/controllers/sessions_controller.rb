class SessionsController < ApplicationController
  skip_before_filter :authenticate_user!

  def create
    session[:user] = {
      id: auth_hash[:uid],
      name: auth_hash[:info][:name],
      email: auth_hash[:info][:email],
      party_registry_profile: auth_hash[:info][:party_registry_profile],
      info: auth_hash[:extra][:raw_info],
      access_token: auth_hash[:info][:access_token],
      refresh_token: auth_hash[:info][:refresh_token]
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
