class Contact < ApplicationRecord
  validates :name, presence: true, length: { minimum: 1, maximum: 20 }
  validates :email, presence: true
  validates :phone_number, numericality: true, length: { maximum: 11 }
  validates :message, presence: true, length: { maximum: 200 }
  enum subject: { other: 0, work: 1, othermethod: 2 }
end
