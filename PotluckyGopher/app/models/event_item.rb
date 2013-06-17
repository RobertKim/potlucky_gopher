class EventItem < ActiveRecord::Base
  attr_accessible :event_id, :description, :item_id, :quantity_needed, :_destroy

  validates :quantity_needed, :presence => true#, :message => "Please tell your guest how much you need."
  validates :quantity_needed, :numericality => {
    :only_integer => true,
    :greater_than_or_equal_to => 0
  }
  validates :description, :length => { :maximum => 140 }

  has_many :assigned_items
  belongs_to :event, :inverse_of => :event_items
  belongs_to :item, :inverse_of => :event_items

  def quantity_still_needed
    provided_items = 0
    self.assigned_items.each do |item|
      provided_items += item.quantity_provided
    end
    quant_needed = self.quantity_needed - provided_items
    quant_needed >= 0 ? quant_needed : 0
  end

  def update_quant_needed
    self.update_attribute("quantity_needed", self.quantity_still_needed)
  end
end
