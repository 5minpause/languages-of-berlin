require 'rubygems'
require 'sinatra'
require 'thin'
require 'haml'
require 'json'
require 'net/http'

class GoogleMapsApi
  attr_accessor :formatted_address, :lat, :lng, :metro
  def initialize( address, city, state )
    @address = address
    @city = city
    @state = state
    @geocode_url = create_geocode_url
    @results = get_json_response
    @formatted_address = @results['results'][0]['formatted_address']
    @lat = @results['results'][0]['geometry']['location']['lat']
    @lng = @results['results'][0]['geometry']['location']['lng']
    @metro = get_metro_area
  end

  def create_geocode_url
    url = 'http://maps.googleapis.com/maps/api/geocode/json?'
    address = "address=#{@address} #{@city} #{@state}"
    url + address.gsub(" ","+") + '&sensor=true'
  end

  def get_json_response
    response = Net::HTTP.get_response(URI.parse(URI.encode(@geocode_url.strip)))
    JSON.parse(response.body)
  end

  def get_metro_area
    @results['results'][0]['address_components'].each do |value|
      if value['types'][0] == 'administrative_area_level_3'
        return value['long_name']
      end
    end
  end
end

get '/' do
  haml :form
end

post '/' do
  if params.any?
    address = params[:address]
    city    = params[:city]
    state   = params[:state]

    geo_object = GoogleMapsApi.new(address, city, state)
    "coordinates are lat: #{geo_object.lat}, lng: #{geo_object.lng}"
  end
end
