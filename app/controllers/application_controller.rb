class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  before_action :set_locale
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Overwrite the method sorcery calls when it
  # detects a non-authenticated request.
  def not_authenticated
    # Make sure that we reference the route from the main app.
    redirect_to main_app.login_path
  end

  private

  def set_locale
    locale = current_user&.locale ||
             params[:user_locale] ||
             session[:locale] ||
             http_accept_language.compatible_language_from(I18n.available_locales) ||
             I18n.default_locale

    session[:locale] = I18n.locale = locale
  end

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to(request.referrer || main_app.root_path)
  end

  def require_admin
    current_user && current_user.has_role?(:admin)
  end
end
