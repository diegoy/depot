class StoreController < ApplicationController
  def index
    @products = Product.order(:title)
    @cart = current_cart
    if session[:counter].nil?
      session[:counter] = 0
    end
    session[:counter] += 1
  end
end
