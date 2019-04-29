class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.references :client, foreign_key: true, null: false
      t.string :imei, limit: 14, null: false
      t.string :phone_model, null: false
      t.decimal :full_price, precision: 10, scale: 2, null: false
      t.integer :payments, null: false

      t.timestamps
    end
  end
end
