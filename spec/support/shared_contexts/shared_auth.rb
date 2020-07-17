shared_context 'authorized user', auth: true do
  include_context 'users'
  before { login(user) }
end

shared_context 'unauthorized user', unauth: true do
  before { logout(user) }
end
