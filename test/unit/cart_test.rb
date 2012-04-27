require 'test_helper'

class CartTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "create a new cart and add two distinct products" do
    cart = Cart.create
    
    cart.add_product(products(:one).id).save!
    cart.add_product(products(:ruby).id).save!
    
    assert_equal 2, cart.line_items.size
    assert_equal products(:one).price + products(:ruby).price, cart.total_price
  end

  test "create a new cart and add duplicate entries" do
    cart = Cart.create
    product = products(:ruby)

    cart.add_product(product.id).save!
    
    cart.add_product(product.id).save!
    
    assert_equal 1, cart.line_items.size
    assert_equal 2, cart.line_items[0].quantity
  end
end
