class Category < ApplicationRecord
  has_many :tasks, dependent: :destroy
  belongs_to :user

  validates :name, presence: true, length: { maximum: 20 }
  validates :description, length: { maximum: 100 }
end
