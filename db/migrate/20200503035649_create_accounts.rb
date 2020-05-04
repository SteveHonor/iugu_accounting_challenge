class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts, id: false do |t|
      t.string :id, unique: true, primary_key: true
      t.string :name
      t.decimal :balance, precision: 14, scale: 2
      t.references :customer, foreign_key: true

      t.timestamps
    end
  end
end
