class CreateExpenseItems < ActiveRecord::Migration[6.1]
  def change
    create_table :expenses_items do |t|
      t.belongs_to :expense, index: true
      t.belongs_to :item, index: true
      t.timestamps
    end
  end
end
