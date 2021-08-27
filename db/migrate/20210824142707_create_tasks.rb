class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :name
      t.date :due_date
      t.string :details
      t.boolean :completed, default: false
      t.integer :category_id

      t.timestamps
    end
  end
end
