class Task < ApplicationRecord
  belongs_to :category
  validate :due_date_not_past

  validates :name, presence: true
  validates :details, length: { maximum: 100 }
  validates :due_date, presence: true
  validates :category_id, presence: true

  private

  def due_date_not_past
    return if due_date.nil? || due_date.today?

    if due_date.past?
      errors.add(:due_date, "can't be in the past")
    end
  end
end
