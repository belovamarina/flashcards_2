class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale

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
end
