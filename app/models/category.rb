class Category < ApplicationRecord
  has_many :tasks, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :description, length: { maximum: 100 }
end
