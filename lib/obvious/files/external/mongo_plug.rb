require 'moped'

class MongoPlug
  def initialize collection
    @collection = collection
    @session = MONGO_SESSION
  end

  def list
    result = @session[@collection].find.entries
    result.map! do |entry|
      clean_up entry 
    end

    result
  end

  def get input
    result = symbolize_keys @session[@collection].find(:id => input[:id]).first
    clean_up result
  end

  def save input
    if input[:id] == -1
      id = @session[:counters].find(:_id => @collection).modify({ "$inc" => { seq: 1 } }, new:true)["seq"]
      input[:id] = id
    end
    result = @session[@collection].find(:id => input[:id]).modify(input, upsert: true, new: true)
    clean_up result
  end

  def remove input
    @session[@collection].find(:id => input[:id]).remove
    true
  end

  def clean_up input
    result = symbolize_keys input
    result.delete :_id
    result
  end

  def symbolize_keys hash
    hash.inject({}){|result, (key, value)|
      new_key = case key
                when String then key.to_sym
                else key
                end
      new_value = case value
                  when Hash then symbolize_keys(value)
                  else value
                  end
      result[new_key] = new_value
      result
    }
  end
end
