class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    if is_navigational_format?
      redirect_to root_path, alert: exception.message
    else
      render status: :forbidden
    end
  end

  check_authorization unless: :devise_controller?
end
