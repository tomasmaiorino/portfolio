class CreateCompanies < ActiveRecord::Migration[5.0]
  def change
    create_table :companies do |t|
      t.belongs_to :client, index: true
      t.boolean :active, :default => false
      t.string :token
      t.string :email
      t.string :manager_name
      t.string :name

      t.timestamps
    end

    create_table :companies_projects, id: false do |t|
      t.belongs_to :project, index: true
      t.belongs_to :company, index: true
    end

    create_table :projects_tech_tags, id: false do |t|
      t.belongs_to :project, index: true
      t.belongs_to :tech_tag, index: true
    end

    create_table :companies_skills, id: false do |t|
      t.belongs_to :skill, index: true
      t.belongs_to :company, index: true
    end

  end
end
