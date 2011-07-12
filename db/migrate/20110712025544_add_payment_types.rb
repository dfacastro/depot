class AddPaymentTypes < ActiveRecord::Migration
  def self.up
    PaymentType.create(:name => "Check")
    PaymentType.create(:name => "Credit Card")
    PaymentType.create(:name => "Purchase Order")
  end

  def self.down
    PaymentType.delete_all
  end
end
