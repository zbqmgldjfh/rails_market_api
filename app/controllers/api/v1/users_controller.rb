class Api::V1::UsersController < ApplicationController

  def show
    find_user = User.find(params[:id])
    render json: find_user, serializer: Api::V1::UserDetailSerializer
  end

  def create
    @new_user = User.new(user_params)

    if @new_user.save
      return render json: @new_user, status: :created
    end

    render json: @new_user.errors, status: :unprocessable_entity
  end

  private def user_params
    params.require(:user).permit(:email, :password)
  end

end
