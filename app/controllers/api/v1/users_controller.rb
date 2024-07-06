class Api::V1::UsersController < ApplicationController

  before_action :set_user, only: %i[show update destroy]
  before_action :check_owner, only: %i[update destroy]

  def show
    options = { include: [:products] }
    render json: UserSerializer.new(@user, options).serializable_hash
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: UserSerializer.new(@user).serializable_hash, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render UserSerializer.new(@user).serializable_hash, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    head 204
  end

  private def set_user
    @user = User.find(params[:id])
  end

  private def user_params
    params.require(:user).permit(:email, :password)
  end

  private def check_owner
    head :forbidden unless current_user&.id == @user.id
  end
end
