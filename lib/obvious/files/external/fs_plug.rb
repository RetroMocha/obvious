require 'json'

class FsPlug 

  def initialize filename
    @filename = filename
  end

  def save input
    # open the file
    contents = File.read @filename

    data = []
    # parse the json list
    query = JSON.parse contents, :symbolize_names => true

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
    input[:id] = max_id + 1
    data << input if new_element

    # save the data back to FS
    json_data = JSON.pretty_generate data 
    File.open(@filename, 'w') {|f| f.write(json_data) }

    # return the transformed data
    input
  end

  def list
    # open the file
    contents = File.read @filename

    # parse the json list
    data = JSON.parse contents, :symbolize_names => true
    
    # return the transformed data
    data 
  end
  
  def get input
    # open the file
    contents = File.read @filename

    data = []
    # parse the json list
    query = JSON.parse contents, :symbolize_names => true

    # transform the data if needed
    query.each do |h|
      return h if h[:id] == input[:id]
    end 

    {} 
  end

  def remove input
    # open the file
    contents = File.read @filename

    data = []
    # parse the json list
    query = JSON.parse contents, :symbolize_names => true

    # transform the data if needed
    query.each do |h|
      unless h[:id] == input[:id]
        data << h 
      end
    end

    # save the data back to FS
    json_data = JSON.pretty_generate data 
    File.open(@filename, 'w') {|f| f.write(json_data) }

    # return true on success
    true 
  end

end



