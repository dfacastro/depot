require 'test_helper'

class ShippingOrdersTest < ActionDispatch::IntegrationTest
  fixtures :all
  
  test "shipping an order" do
    order = orders(:one)

    # visit the orders page
    get "/orders"
    assert_response :success
    assert_template "index"

    # choose to ship order 'one'
    post_via_redirect "/orders/ship_order", :id => order.id
    assert_response :success
    assert_template "index"

    assert Order.find(order.id).ship_date

    # verify if the email was sent
    mail = ActionMailer::Base.deliveries.last
    assert_equal 'Pragmatic Store Order Shipped', mail.subject
    assert_equal [order.email], mail.to
    assert_equal 'Diogo Castro <depot@example.com>', mail[:from].value
  end
end
