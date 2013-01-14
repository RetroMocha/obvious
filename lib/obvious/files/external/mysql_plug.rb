require 'sequel'

# assume that DB is defined as a global constant elsewhere

class MysqlPlug 

  def initialize table
    @table = table
  end

  def save input
    table = DB[@table]
    input[:id] = nil if input[:id] == -1

    # this does an upsert
    result = table.on_duplicate_key_update.insert input

    input[:id] = result
    input
  end

  def list
    table = DB[@table]
    table.all
  end

  def get input
    table = DB[@table]
    table.first :id => input[:id]
  end

  def remove input
    table = DB[@table]
    result = table.where(:id => input[:id]).delete
    return true if result == 1
    false
  end
end
