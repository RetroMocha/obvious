require 'rest-client'

class ApiPlug
  def initialize entity
    @url = 'http://localhost:9394'
    @entity = entity
  end

  def list
    response = RestClient.get "#{@url}/#{@entity}/list"
    JSON.parse response, :symbolize_names => true
  end

  def get input
    response = RestClient.get "#{@url}/#{@entity}/#{input[:id]}"
    JSON.parse response, :symbolize_names => true
  end

  def save input
    url = "#{@url}/#{@entity}"
    if input[:id] == -1
      url << "/create"
    else
      url << "/#{@input[:id]}/update"
    end
    response = RestClient.post url, input
    JSON.parse response, :symbolize_names => true
  end

  def remove input
    response = RestClient.post "#{@url}/#{@entity}/#{input[:id]}/remove", input
    result = JSON.parse response, :symbolize_names => true
    result[:success]
  end
end
