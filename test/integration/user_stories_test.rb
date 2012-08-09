require 'test_helper'
require 'date'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products
  fixtures :payment_types

  def make_login
    get login_url
    post_via_redirect login_url,
      name: "dave",
      password: "secret"
  end

  test "buying a product" do
    LineItem.delete_all
    Order.delete_all
    ruby_book = products(:ruby)

    get "/"
    assert_response :success
    assert_template "index"

    xml_http_request :post, '/line_items', product_id: ruby_book.id
    assert_response :success

    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product

    make_login

    get "/orders/new"
    assert_response :success
    assert_template "new"

    check_payment_type = payment_types(:check)
    post_via_redirect "/orders",
          order: { name: "Dave Thomas",
                   address: "123 The Street",
                   email: "dave@example.com",
                   payment_type_id: check_payment_type.id}

    assert_response :success
    assert_template "index"
    cart = Cart.find(session[:cart_id])
    assert_equal 0, cart.line_items.size

    orders = Order.all
    assert_equal 1, orders.size
    order = orders[0]

    assert_equal "Dave Thomas", order.name
    assert_equal "123 The Street", order.address
    assert_equal "dave@example.com", order.email
    assert_equal check_payment_type.id, order.payment_type.id
    assert_equal Date.today, order.ship_date.to_date

    assert_equal 1, order.line_items.size
    line_item = order.line_items[0]
    assert_equal ruby_book, line_item.product

    mail = ActionMailer::Base.deliveries.last
    assert_equal ["dave@example.com"], mail.to
    assert_equal 'from@example.com', mail[:from].value
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
  end

  test "access invalid cart number" do
    Cart.delete_all

    make_login

    get "/carts/1"
    assert_response :redirect
    assert_template "/"

    mail = ActionMailer::Base.deliveries.last
    assert_equal ["developer@example.com"], mail.to
    assert_equal "from@example.com", mail[:from].value
    assert_equal "Server Error", mail.subject
  end

  test "should ask for login" do
    delete logout_path
    assert_redirected_to store_url

    get "/admin"
    assert_redirected_to login_url
  end
end
