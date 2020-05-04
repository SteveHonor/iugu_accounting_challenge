class CreateMovements < ActiveRecord::Migration[6.0]
  def change
    create_table :movements do |t|
      t.integer :kind, default: 0
      t.references :account
      t.decimal :amount, precision: 14, scale: 2

      t.timestamps
    end
  end
end
