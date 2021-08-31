class AddUserIdToCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :user_id, :Integer
  end
end
