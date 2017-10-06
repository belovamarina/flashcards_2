module LoginHelper
  def login(user, email = nil, pass = nil, action)
    click_link action
    fill_in 'email', with: email || user.email
    fill_in 'password', with: pass || '12345'
    click_button action
    user
  end

  def register(user, action)
    visit new_user_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    fill_in 'user[password_confirmation]', with: user.password_confirmation
    click_button action
    user
  end

  def basic_auth(email, pass)
    @env ||= {}
    @env['AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(email, pass)
  end
end
