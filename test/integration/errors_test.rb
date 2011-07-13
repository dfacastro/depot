require 'test_helper'

class ErrorsTest < ActionDispatch::IntegrationTest
  fixtures :all

  # Replace this with your real tests.
  test "accessing invalid cart" do

    # access cart with id = wibble
    get_via_redirect "/carts/wibble"
    assert_response :success
    assert_template "index"

    mail = ActionMailer::Base.deliveries.last
    assert_equal 'Pragmatic Store: error notification', mail.subject
    assert_equal ['b.boy.souljah@gmail.com'], mail.to
    assert_equal 'Diogo Castro <depot@example.com>', mail[:from].value
    

  end
end
