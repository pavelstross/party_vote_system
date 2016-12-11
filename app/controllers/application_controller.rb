class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def current_user
    session[:user]
  end

  def authenticate_user!
    redirect_to '/auth/party_registry' unless current_user
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
  
  helper_method :current_user

  #extract a datetime object from params, useful for receiving datetime_select attributes
  #out of any activemodel
  def parse_datetime_params(params, label, utc_or_local = :local)
    begin
      year   = params[(label.to_s + '(1i)').to_sym].to_i
      month  = params[(label.to_s + '(2i)').to_sym].to_i
      mday   = params[(label.to_s + '(3i)').to_sym].to_i
      hour   = (params[(label.to_s + '(4i)').to_sym] || 0).to_i
      minute = (params[(label.to_s + '(5i)').to_sym] || 0).to_i
      second = (params[(label.to_s + '(6i)').to_sym] || 0).to_i

      return DateTime.civil_from_format(utc_or_local,year,month,mday,hour,minute,second)
    rescue => e
      return nil
    end
  end

end
