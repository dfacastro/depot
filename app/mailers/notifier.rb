class Notifier < ActionMailer::Base
  default :from => 'Diogo Castro <depot@example.com>' #"from@example.com"
  default :to => 'b.boy.souljah@gmail.com'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.order_received.subject
  #
  def order_received(order)
    @order = order
    
    mail :to => order.email, :subject => 'Pragmatic Store Order Confirmation'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.order_shipper.subject
  #
  def order_shipped(order)
    @order = order
    
    mail :to => order.email, :subject => 'Pragmatic Store Order Shipped'
  end

  def error_occurred(notice)
    @notice = notice
    
    mail :subject => 'Pragmatic Store: error notification'
  end
end
