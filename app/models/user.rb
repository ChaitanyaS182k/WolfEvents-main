class User < ApplicationRecord
  has_secure_password

  PASSWORD_FORMAT = /\A
  (?=.*\d)           # Must contain a digit
  (?=.*[a-z])        # Must contain a lower case character
  (?=.*[A-Z])        # Must contain an upper case character
  (?=.*[[:^alnum:]]) # Must contain a symbol
/x

  has_many :tickets, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_and_belongs_to_many :events

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  validates :email, format: {
    with: /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})\z/i,
    message: "is Invalid",
    multiline: true
  }

  validates :password, :presence => true,
            :confirmation => true,
            :length => {:within => 6..225},
            format: { with: PASSWORD_FORMAT },
            :on => :create
  validates :password, :confirmation => true,
            :length => {:within => 6..225},
            :allow_blank => true,
            format: { with: PASSWORD_FORMAT },
            :on => :update

  validates :phone_number,
            format:    { with: /\A\d{10}\z/ },
            length:    { maximum: 10 },
            allow_blank: true

  validates :credit_card_info,
            format:    { with: /\A(\d{4}-){3}\d{4}/ },
            length:    { maximum: 19 },
            allow_blank: true
end
