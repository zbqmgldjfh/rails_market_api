class Api::V1::UsersController < ApplicationController

  before_action :set_user, only: %i[show update]

  def show
    render json: @user, serializer: Api::V1::UserDetailSerializer
  end

  def create
    @new_user = User.new(user_params)

    if @new_user.save
      return render json: @new_user, status: :created
    end

    render json: @new_user.errors, status: :unprocessable_entity
  end

  def update
    if @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  private def user_params
    params.require(:user).permit(:email, :password)
  end

end
