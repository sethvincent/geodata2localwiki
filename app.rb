require 'sinatra'
require 'localwiki_client'
require 'json'

before do
  @site = 'ec2-54-234-151-52.compute-1.amazonaws.com'
  @wiki = LocalwikiClient.new @site, ENV['LOCALWIKI_USER'], ENV['LOCALWIKI_API_KEY']
end

get '/' do
  @sitename = @wiki.site.name
  map = @wiki.fetch(:map, 'Front Page')
  @geodata = map.geom.to_json
  erb :index
end


# todo:
# handle page names better
# allow upload of kml, shp, geojson files
post '/' do
  pagename = params['pagename']
  geodata = JSON.parse(params['geodata'])
  @wiki.create(:page, { name: pagename, content: 'map test' }.to_json)

  @new_map = {
    geom: geodata,
    page: "/api/page/#{pagename}"
  }.to_json

  puts @new_map
  @wiki.create(:map, @new_map)
  
  redirect "/ok?pagename="+ pagename.to_s.strip.gsub(' ', "_")
end

get '/ok' do
  @pizza = params['pagename']
  erb :ok
end  