require "sinatra"
require 'sinatra/reloader'

set :haml, :format => :html5

get "/" do
  @message = "test"
  haml :index
end
