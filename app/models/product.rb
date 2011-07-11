class Product < ActiveRecord::Base

  default_scope :order => 'title'
  has_many :line_items
  has_many :orders, :through => :line_items
  before_destroy :ensure_not_referenced_by_any_line_item



  validates :title, :description, :image_url, :presence => true
  validates :price, :numericality => {:greater_than_or_equal_to => 0.01}
  validates :title, :uniqueness => true
  validates :image_url, :format => {:with => %r{\.(gif|png|jpg)$}i ,
                                    :message => 'must be a URL to a GIF, JPG or PNG image.'}

=begin
  validates :title, :length => { :minimum => 10,
    :message => 'must be at least 10 characters long'
  }
=end

  validate :title_len

  private
  def title_len
    errors.add(:title, 'must be at least 10 characters long') unless title != nil and title.length >= 10
  end

  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, 'Line Iems present')
      return false
    end
  end

end
