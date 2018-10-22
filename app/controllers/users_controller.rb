class UsersController < ApplicationController
  before_action :authenticate_user, except: [:create]

  def create
    user = User.new(user_params)
    user.status = :activated

    if user.save
      return head :no_content
    else
      return render json: { messages: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
    def user_params
      params.permit(:email, :password, :password_confirmation)
    end
end
