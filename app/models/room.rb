class Room < ApplicationRecord
  has_one :event, dependent: :destroy
  has_many :ticket, dependent: :destroy


  validates :location, presence:true
  validates :capacity, presence: true, numericality: {greater_than_or_equal_to: 1}
end
