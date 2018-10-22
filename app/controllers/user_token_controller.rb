class UserTokenController < Knock::AuthTokenController
  rescue_from Exceptions::UserNotFoundError, with: :rescue_user_not_found

  private
  def rescue_user_not_found
    return render json: { messages: [I18n.t('api_errors.singin_error')] }
  end
end
