require 'json'
require 'aws/s3'

class S3Plug
  include AWS::S3

  def initialize input 
    @filename = input[:filename]
    @bucket = input[:bucket]

    # you can test locally with the fake-s3 gem: https://github.com/jubos/fake-s3
    # or just swap out for the filesystem plug locally
    s3_key = ENV['S3_KEY'] || '123'
    s3_secret = ENV['S3_SECRET'] || 'abc'
    s3_server = ENV['S3_SERVER'] || '0.0.0.0'
    s3_port = ENV['S3_PORT'] || '10001'

    AWS::S3::Base.establish_connection!(:access_key_id => s3_key,
                                        :secret_access_key => s3_secret,
                                        :server => s3_server,
                                        :port => s3_port)
  end

  def load_data
    contents = S3Object.value @filename, @bucket
    JSON.parse contents, :symbolize_names => true
  end

  def save_data data
    json_data = JSON.pretty_generate data 
    S3Object.store @filename, json_data, @bucket
  end

  def save input
    data = []
    result = load_data
    new_element = true if input[:id] == -1 # by convention set new element flag if id == -1

    max_id = -1
    # transform the data if needed
    result.each do |h|
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
    result = load_data

    # transform the data if needed
    result.each do |h|
      return h if h[:id] == input[:id]
    end 

    {} 
  end

  def remove input
    data = []
    result = load_data

    # transform the data if needed
    result.each do |h|
      unless h[:id] == input[:id]
        data << h 
      end
    end

    save_data data

    # return true on success
    true 
  end
end

