class Api::V1::OrdersController < ApplicationController
  before_action :check_login, only: %i[index show]

  def index
    render json: OrderSerializer.new(current_user.orders).serializable_hash
  end

  def show
    find_order = current_user.orders.find([params[:id]])

    if find_order
      options = { include: [:products] }
      return render json: OrderSerializer.new(find_order, options).serializable_hash
    end

    head 404
  end

  private def check_login
    head :forbidden unless self.current_user
  end
end
