class Api::V1::UsersController < ApplicationController

  def show
    find_user = User.find(params[:id])
    render json: find_user, serializer: Api::V1::UserDetailSerializer
  end
end
