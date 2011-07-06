require 'test_helper'

class ProductTest < ActiveSupport::TestCase

  fixtures :products

  # Replace this with your real tests.
  test "the truth" do
    assert true
  end

  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
    
  end


  test "product price must be positive" do
    product = Product.new(:title        => 'New Title',
                          :description  => 'New Description',
                          :image_url    => 'New Url.jpg')
    product.price = -1
    assert product.invalid?
    assert_equal product.errors[:price].join('; '), "must be greater than or equal to 0.01"

    product.price = 0
    assert product.invalid?
    assert_equal product.errors[:price].join('; '), "must be greater than or equal to 0.01"

    product.price = 1
    assert product.valid?

  end

  def new_product(image_url)
    Product.new(:title        => 'New Title',
                :description  => 'New Description',
                :price        => 10,
                :image_url    => image_url )
  end

  test "image url" do
    ok = %w{fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif}
    bad = %w{fred.doc fred.gif/more fred.gif.more}

    ok.each {
      |name|
      assert new_product(name).valid?, "#{name} shouldn't be invalid"
    }

    bad.each {
      |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    }
  end

  test "product is not valid without a unique title" do
    product = Product.new(  :title          => products(:ruby).title,
                            :description    => "yyy",
                            :price          => 1,
                            :image_url      => "fred.gif")

    assert !product.save
    #assert_equal "has already been taken", product.errors[:title].join('; ')
    assert_equal I18n.translate('activerecord.errors.messages.taken'), product.errors[:title].join('; ')
  end

end
