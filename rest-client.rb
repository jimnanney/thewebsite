require 'rest-client'
require 'json'

class ImageSearcher
  attr_accessor :url

  def search(search_query)
    images = search_for_images(search_query)
    @url = url_for_image(images)
  end

  def default_image_url
    'http://www.google.com/'
  end

  def search_for_images(query)
    args = { q: query, safe: 'active', v: '1.0', rsz: '8' }
    response = RestClient.get  'http://ajax.googleapis.com/ajax/services/search/images', params: args
    case response.code
    when 200
        json = JSON.parse(response.to_str) 
        json['responseData']['results']
    else
        []
    end
  end

  def url_for_image(result = [])
    result.empty? ? default_image_url : result.sample['url'] 
  end

end

if __FILE__ == $0
  searcher = ImageSearcher.new()
  searcher.search(ARGV.flatten)
  puts searcher.url
end

