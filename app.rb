require 'sinatra'
require 'localwiki_client'
require 'json'
require 'uri'

get '/' do
  erb :index
end

# todo:
# allow upload of kml, shp, geojson files
post '/' do
  uri = URI.parse(params['url'])
  uri = URI.parse("http://#{params['url']}") if uri.scheme.nil?

  @site = uri.host.downcase
  @wiki = LocalwikiClient.new @site, params['username'], params['apikey']

  pagename = params['pagename']
  geodata = JSON.parse(params['geodata'])
  @wiki.create(:page, { name: pagename, content: '' }.to_json)

  @new_map = {
    geom: geodata,
    page: "/api/page/#{pagename}"
  }.to_json

  @wiki.create(:map, @new_map)
  
  pagename = pagename.to_s.strip.gsub(' ', "_")
  redirect "/ok?pagename=#{pagename}&url=#{@site}"
end

get '/ok' do
  @pagename = params['pagename']
  @site = params['url']
  @wiki = LocalwikiClient.new @site
  @page = @wiki.fetch(:page, @pagename)
  erb :ok
end  