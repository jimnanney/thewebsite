require 'rest-client'
require 'json'

def imageMe(query)
  args = { q: query, safe: 'active', v: '1.0', rsz: '8' }
  response = RestClient.get  'http://ajax.googleapis.com/ajax/services/search/images', params: args
  case response.code
  when 200
      json = JSON.parse(response.to_str) 
      images =json['responseData']['results']
  else
      images = []
  end
end

def image(result = [])
  result.sample
end

puts imageMe("meme").sample

