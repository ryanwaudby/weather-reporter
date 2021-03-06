require "sinatra"
require 'sinatra/reloader'
require 'open-uri'
require "json"

set :haml, :format => :html5

def fahrenheit_to_celsius(f)
  (f - 32) * 5.0 / 9.0
end

get "/" do
  haml :index
end

get "/weather/:location" do
  content_type :json
  FORCAST_URL = "https://api.forecast.io/forecast/fde80a8eb6c50e90b06661eb5c6840fd/"
  GOOGLE_MAPS_CONVERSION_URL = "http://maps.googleapis.com/maps/api/geocode/json?sensor=true%27&address="

  location_data = JSON.parse(open("#{GOOGLE_MAPS_CONVERSION_URL}#{params[:location]}").read)
  coordinates = location_data["results"][0]["geometry"]["viewport"]["northeast"]
  report = JSON.parse(open("#{FORCAST_URL}#{coordinates["lat"]},#{coordinates["lng"]}").read)["hourly"]

  chart_labels = report["data"].map { |data|
    DateTime.strptime(data["time"].to_s, '%s').strftime("%H:%M")
  }

  chart_data_points = report["data"].map { |data|
    fahrenheit_to_celsius data["temperature"]
  }

  {
    summary: report["summary"],
    chart_data: {
      labels: chart_labels,
      datasets: [
      {
        label: "Weather",
        fillColor: "rgba(151,187,205,0.2)",
        strokeColor: "rgba(151,187,205,1)",
        pointColor: "rgba(151,187,205,1)",
        pointStrokeColor: "#fff",
        pointHighlightFill: "#fff",
        pointHighlightStroke: "rgba(151,187,205,1)",
        data: chart_data_points
      }]
    }
  }.to_json
end
