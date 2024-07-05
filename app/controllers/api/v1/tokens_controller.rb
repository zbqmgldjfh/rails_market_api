class Api::V1::TokensController < ApplicationController
  def create
    @user = User.find_by_email(user_params[:email])

    if @user&.authenticate(user_params[:password])
      return render json: {
        token: JsonWebToken.encode({user_id: @user.id}),
        email: user_params[:email]
      }
    end

    head :unauthorized
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
