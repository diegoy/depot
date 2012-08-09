#---
# Excerpted from "Agile Web Development with Rails",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rails4 for more book information.
#---
class ApplicationController < ActionController::Base
  before_filter :authorize
  protect_from_forgery

  private

    def current_cart 
      Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
      cart = Cart.create
      session[:cart_id] = cart.id
      cart
    end

    protected

      def authorize
        if User.count.zero?
          redirect_to new_user_path unless session[:new_user]
          return
        end

        unless User.find_by_id(session[:user_id])
          if request.format == Mime::HTML
            redirect_to login_url, notice: "Please log in"
          elsif
            if user = authenticate_with_http_basic do |u, p|
                  finded_user = User.find_by_name(u)
                  finded_user.authenticate(p) if finded_user
              end
              session[:user_id] = user.id
            elsif
              render :status => 403, :text => "login failed" and return
            end
          end
        end
      end
end
