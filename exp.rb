require 'localwiki_client'
require 'json'

@wiki = LocalwikiClient.new 'ec2-54-234-151-52.compute-1.amazonaws.com', ENV['LOCALWIKI_USER'], ENV['LOCALWIKI_API_KEY']

pagename = 'testing map creation 7'
@map = @wiki.fetch(:map, 'Front Page')

@new_map = {
  geom: @map.geom,
  page: "/api/page/#{pagename}"
}.to_json

page = @wiki.create(:page, { name: pagename, content: 'map test' }.to_json)
puts @map.geom.to_json
@wiki.create(:map, @new_map)
