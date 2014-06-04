class MapsController < ApplicationController
  def index
    @hash = all_companies_hash
  end

  def geocode_and_add
    if company_params.any?
      @geocoder = Geocoder.new(company_params[:street], company_params[:city], company_params[:country])

      if @geocoder.lat && @geocoder.lng
        company_hash = company_params
        company_hash = {lng: @geocoder.lng, lat: @geocoder.lat}.merge(company_hash)
        Company.create!(company_hash)
        @hash = all_companies_hash
      end
    end
  end

  private

  def company_params
    params.require(:company).permit(:title, :street, :city, :country, :url)
  end

  def all_companies_hash
    @companies = Company.all
    @hash = Gmaps4rails.build_markers(@companies) do |company, marker|
      marker.picture({
        :picture => "http://www.blankdots.com/img/github-32x32.png",
        :width   => 32,
        :height  => 32
      })
      marker.lat company.lat
      marker.lng company.lng
      marker.title company.title
      marker.json({id: company.id, title: company.title})
    end
  end
end
