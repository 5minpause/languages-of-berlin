class AddLatAndLngToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :lat, :float
    add_column :companies, :lng, :float
  end
end
