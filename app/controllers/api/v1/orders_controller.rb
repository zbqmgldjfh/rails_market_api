class Api::V1::OrdersController < ApplicationController
  before_action :check_login, only: %i[index show create]

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

  def create
    new_order = current_user.orders.build(order_params)

    if new_order.save
      render json: new_order, status: 201
    else
      render json: { errors: new_order.errors }, status: 422
    end
  end

  private def order_params
    params.require(:order).permit(:total, product_ids: [])
  end

  private def check_login
    head :forbidden unless self.current_user
  end
end
