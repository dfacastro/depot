class StoreController < ApplicationController
  def index
    @products = Product.all
    @cart = current_cart
    inc_count
  end

end
