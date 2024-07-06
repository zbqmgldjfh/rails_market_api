class Api::V1::ProductsController < ApplicationController
  before_action :set_product, only: %i[show update destroy]
  before_action :check_login, only: %i[create]
  before_action :check_owner, only: %i[update destroy]

  def show
    render json: Product.find(params[:id])
  end

  def index
    render json: Product.all
  end

  def create
    new_product = current_user.products.build(product_params)
    if new_product.save
      return render json: new_product, status: :created
    end

    render json: { errors: new_product.errors }, status: :unprocessable_entity
  end

  def update
    if @product.update(product_params)
      return render json: @product
    end

    render json: @product.errors, status: :unprocessable_entity
  end

  def destroy
    @product.destroy
    head 204
  end

  private def product_params
    params.require(:product).permit(:title, :price, :published)
  end

  private def check_owner
    head :forbidden unless @product.user_id == current_user&.id
  end

  private def set_product
    @product = Product.find(params[:id])
  end

  protected def check_login
    head :forbidden unless self.current_user
  end
end
