class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :title
      t.string :street
      t.string :city
      t.string :country
      t.string :url

      t.timestamps
    end
  end
end
