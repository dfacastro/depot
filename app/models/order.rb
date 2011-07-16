class Order < ActiveRecord::Base

  has_many :line_items, :dependent => :destroy
  has_many :products, :through => :line_items

  #PAYMENT_TYPES = PaymentType::ALL # ["Check", "Credit Card", "Purchase Order"]
  if PaymentType::ALL.count > 0
    PAYMENT_TYPES = PaymentType::ALL
  else
    PAYMENT_TYPES = ["Check", "Credit Card", "Purchase Order"]
  end

  validates :name, :email, :pay_type, :address, :presence => true
  validates :pay_type, :inclusion => PAYMENT_TYPES


  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end
end
