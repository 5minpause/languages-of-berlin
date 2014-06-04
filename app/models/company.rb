class Company < ActiveRecord::Base
  validates_presence_of :title, :city, :street, :lat, :lng
end
