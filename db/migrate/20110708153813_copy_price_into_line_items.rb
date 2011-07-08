class CopyPriceIntoLineItems < ActiveRecord::Migration
  def self.up
    LineItem.all.each do |line_item|
      line_item.price = line_item.product.price
      line_item.save
    end
  end

  def self.down
    LineItem.all.each do |line_item|
      line_item.price = nil
      line_item.save
    end
  end
end
