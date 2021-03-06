class StoreController < ApplicationController
  skip_before_filter :authorize
  def index
    if params[:set_locale]
      redirect_to store_path(locale: params[:set_locale])
    else
      @products = Product.where(locale: I18n.locale).order(:title)
      @cart = current_cart
    end
    @products = Product.where(locale: I18n.locale).order(:title)
    @cart = current_cart
    if session[:counter].nil?
      session[:counter] = 0
    end
    session[:counter] += 1
  end
end
