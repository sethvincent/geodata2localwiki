require 'localwiki_client'
require 'json'

@wiki = LocalwikiClient.new 'seattlewiki.net', 'sethvincent', '0e6580eb57932a358a84977d1ca1fe4343cda85b'

pagename = 'testing map creation 7'
@map = @wiki.fetch(:map, 'Capitol_Hill')

puts @map.geom.to_json
