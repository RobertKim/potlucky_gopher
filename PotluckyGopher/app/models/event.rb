class Event < ActiveRecord::Base
  attr_accessible :date, :description, :end_time, :host_provided, :location, :name, :start_time, :type, :url, :user_id

  belongs_to :user
  has_many :event_items
  has_many :items, :through => :event_items
end