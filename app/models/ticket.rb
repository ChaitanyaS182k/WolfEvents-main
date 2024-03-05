class Ticket < ApplicationRecord
  belongs_to :user
  belongs_to :event
  belongs_to :whom, class_name: 'User', foreign_key: 'whom_id', optional: true

  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :confirmation_number, presence: true, uniqueness: true
end
