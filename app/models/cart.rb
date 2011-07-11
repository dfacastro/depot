class Cart < ActiveRecord::Base
  has_many :line_items, :dependent => :destroy

  def add_product(product_id)
    current_item = line_items.find_by_product_id(product_id)
    if current_item
      current_item.quantity += 1
    else
      current_item = line_items.build(:product_id => product_id)
    end
    current_item.price = Product.find(product_id).price
    current_item
  end


  def total_price
    line_items.to_a.sum { |item| item.total_price }
  end

  def total_items
    line_items.sum(:quantity)
  end

  def dec_quantity(line)
    if line.quantity > 1
      line.quantity -= 1
      line.save
      line
    else
      line.destroy
      false
    end
  end

end
