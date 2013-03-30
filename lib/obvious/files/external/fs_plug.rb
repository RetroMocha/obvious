require 'json'

class FsPlug 

  def initialize filename
    @filename = filename
  end

  def load_data
    contents = File.read @filename
    JSON.parse contents, :symbolize_names => true
  end

  def save_data input
    json_data = JSON.pretty_generate input 
    File.open(@filename, 'w') {|f| f.write(json_data) }
  end

  def save input
    data = []
    query = load_data 

    new_element = true if input[:id] == -1 # by convention set new element flag if id == -1

    max_id = -1
    # transform the data if needed
    query.each do |h|
      if input[:id] == h[:id]
        h = input
      end
      max_id = h[:id] if h[:id] > max_id
      data << h
    end

    # add data to the list if it's a new element 
    if new_element 
      input[:id] = max_id + 1
      data << input 
    end

    save_data data

    # return the transformed data
    input
  end

  def list
    load_data
  end
  
  def get input
    data = []
    query = load_data 

    # transform the data if needed
    query.each do |h|
      return h if h[:id] == input[:id]
    end 

    raise Exception.new 'no object found'
  end

  def remove input
    data = []
    # parse the json list
    query = load_data 

    # transform the data if needed
    query.each do |h|
      unless h[:id] == input[:id]
        data << h 
      end
    end

    save_data data

    # return true on success
    true 
  end

  def find input
    data = []
    query = load_data 
 
    key = input.keys[0] 
 
    query.each do |h|
      if input[key] == h[key]
        return h
      end
    end 

    raise Exception.new 'no object found'
  end
end




