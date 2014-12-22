require "sinatra"
require 'sinatra/reloader'

set :haml, :format => :html5

get "/" do
  haml :index
end
