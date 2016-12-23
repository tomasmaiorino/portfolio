class CreateRatings < ActiveRecord::Migration[5.0]
  def change
    create_table :ratings do |t|
      t.belongs_to :company, index: true
      t.integer :points, :default => 0
      t.text :comments
      t.timestamps
    end
  end
end
