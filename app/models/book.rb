class Book < ApplicationRecord
  has_many :pages

  validates :name, presence: true
end
