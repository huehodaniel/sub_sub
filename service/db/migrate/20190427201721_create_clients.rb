class CreateClients < ActiveRecord::Migration[5.2]
  def change
    create_table :clients do |t|
      t.string :name, null: false
      t.string :cpf, limit: 14, null: false
      t.string :email, null: false

      t.timestamps
    end
    add_index :clients, :cpf, unique: true
    add_index :clients, :email
  end
end
