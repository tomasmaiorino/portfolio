class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :img
      t.string :link_img
      t.string :summary
      t.text :description
      t.text :improvements
      t.text :activities_done
      t.string :time_spent
      t.string :language, :default => 'en'
      t.boolean :active, :default => false
      t.boolean :future_project, :default => false
      t.timestamp :project_date

      t.timestamps
    end
  end
end
