class Event < ApplicationRecord
  has_and_belongs_to_many :users
  belongs_to :room
  has_many :ticket, dependent: :destroy
  has_many :reviews

  validates :name, presence:true
  validates :category, presence:true
  validates :date, presence:true
  validates :start_time, presence:true
  validates :end_time, presence:true
  validates :seats_left,presence:true
  validates :ticket_price,presence: true

end
