class CreateTechTags < ActiveRecord::Migration[5.0]
  def change
    create_table :tech_tags do |t|
      t.string :name
      t.boolean :active, :default => false
      t.timestamps
    end
  end
end
