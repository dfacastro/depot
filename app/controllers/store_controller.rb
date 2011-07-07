class StoreController < ApplicationController
  def index
    @products = Product.all
    inc_count
  end

end
