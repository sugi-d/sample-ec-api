module AuthenticationHelpers
  def authorization(user)
    token = Knock::AuthToken.new(payload: { id: user.id, token: user.login_token }).token
    { 'Authorization' => "Bearer #{token}" }
  end
end
