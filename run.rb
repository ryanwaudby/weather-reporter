require "sinatra"
require 'sinatra/reloader'
require 'open-uri'
require "json"

set :haml, :format => :html5

get "/" do
  haml :index
end

get "/weather/:coordinates" do
  content_type :json
  FORCAST_URL = "https://api.forecast.io/forecast/fde80a8eb6c50e90b06661eb5c6840fd/"

  split_coordinates = params[:coordinates].split(", ")
  report = JSON.parse(open("#{FORCAST_URL}#{split_coordinates[0]},#{split_coordinates[1]}").read)["hourly"]

  chart_labels = report["data"].map { |data|
    DateTime.strptime(data["time"].to_s, '%s').strftime("%H:%M")
  }

  chart_data_points = report["data"].map { |data|
    data["temperature"]
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
