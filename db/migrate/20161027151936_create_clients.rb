class CreateClients < ActiveRecord::Migration[5.0]
  def change
    create_table :clients do |t|
      t.string :name
      t.boolean :active, :default => false
      t.string :token
      t.integer :security_permissions, :default => 0

      t.timestamps
    end
  end
end
