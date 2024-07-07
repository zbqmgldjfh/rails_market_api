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
    order = Order.create!(user: current_user)
    order.build_placements_with_product_ids_and_quantities(order_params[:product_ids_and_quantities])

    if order.save
      render json: order, status: :created
    else
      render json: { errors: order.errors }, status: :unprocessable_entity
    end
  end

  private def order_params
    params.require(:order).permit(product_ids_and_quantities: [:product_id, :quantity])
  end

  private def check_login
    head :forbidden unless self.current_user
  end
end
