module FeatureHelpers
  def login(user)
    # visit new_user_session_path
    # fill_in 'Email', with: user.email
    # fill_in 'Password', with: user.password
    # click_on 'Log in'

    page.set_rack_session('warden.user.user.key' => User.serialize_into_session(user))
  end
end
