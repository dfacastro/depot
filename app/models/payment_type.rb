class PaymentType < ActiveRecord::Base
  #collects all names
  ALL = PaymentType.find(:all, :order => :name).collect {|type| type.name }
end
