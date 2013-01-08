require 'obvious/version'
require 'obvious/contract'
require 'yaml'

module Obvious
  # Your code goes here...
  def self.generate
    puts 'generate the codes!a'



#`rm -rf app`

app_dir = 'app'

counter = 1
while File.directory? app_dir
  app_dir = "app_#{counter}"
  counter += 1
end

puts "Generating application at: #{app_dir}"

dirs = ['/', '/actions', '/contracts', '/entities',
        '/spec', '/spec/actions', '/spec/contracts', '/spec/entities',
        '/spec/doubles']

dirs.each do |dir|
  Dir.mkdir app_dir + dir
end


target_path = File.realpath Dir.pwd
spec = Gem::Specification.find_by_name("obvious")
gem_root = spec.gem_dir
gem_lib = gem_root + "/lib"

#`cp #{gem_lib}/obvious/files/contract.rb #{target_path}/app/contracts/contract.rb`
`cp #{gem_lib}/obvious/files/Rakefile #{target_path}/Rakefile`
entities = Hash.new
jacks = Hash.new

files = Dir['descriptors/*.yml']

files.each do |file|
  action = YAML.load_file file
  code = ''
  #puts action.inspect

  local_jacks = Hash.new
  local_entities = Hash.new

  action['Code'].each do |entry|
    code << "    \# #{entry['c']}\n"
    code << "    \# use: #{entry['requires']}\n" if entry['requires']
    code << "    \n"

    if entry['requires']
      requires = entry['requires'].split(',')
      requires.each do |req|
        req.strip!
        info = req.split '.'

        if info[0].index 'Jack'
          unless jacks[info[0]]
            jacks[info[0]] = []
          end

          unless local_jacks[info[0]]
            local_jacks[info[0]] = []
          end

          jacks[info[0]] << info[1]
          local_jacks[info[0]] << info[1]
        else
          unless entities[info[0]]
            entities[info[0]] = []
          end

          unless local_entities[info[0]]
            local_entities[info[0]] = []
          end

          entities[info[0]] << info[1]
          local_entities[info[0]] << info[1]
        end

      end
    end

  end


  jack_inputs = ''
  jack_assignments = ''

  local_jacks.each do |k, v|
    name = k.chomp('Jack').downcase
    jack_inputs << "#{name}_jack, "
    jack_assignments << "    @#{name}_jack = #{name}_jack\n"
  end

  jack_inputs.chomp! ', '

  entity_requires = ''

  local_entities.each do |k, v|
    name = k.downcase
    entity_requires << "require_relative '../entities/#{name}'\n"
  end


  output = <<FIN
#{entity_requires}
class #{action['Action']}

  def initialize #{jack_inputs}
#{jack_assignments}  end

  def do input
#{code}  end

end
FIN
  snake_name = action['Action'].gsub(/(.)([A-Z])/,'\1_\2').downcase

  filename = "#{app_dir}/actions/#{snake_name}.rb"
  File.open(filename, 'w') {|f| f.write(output) }

#puts output

  output = <<FIN
require_relative '../../actions/#{snake_name}'

describe #{action['Action']} do

  it '#{action['Description']}'

  it 'should raise an error with invalid input'

end


FIN

  filename = "#{app_dir}/spec/actions/#{snake_name}_spec.rb"
  File.open(filename, 'w') {|f| f.write(output) }

  #puts output
end


#filter out duplicate methods

entities.each do |k, v|
  v.uniq!
end

jacks.each do |k,v|
  v.uniq!
end

#puts entities.inspect
#puts jacks.inspect

entities.each do |k, v|
  name = k
  method_specs = ''
  method_definitions = ''

  v.each do |method|
    method_definitions << "
  def #{method} input
    nil
  end
    "

    method_specs << "
  describe '.#{method}' do
    it 'should #{method} with valid input'

    it 'should raise an error with invalid input'

  end
    "

  end

  output = <<FIN
class #{name}
#{method_definitions}
end
FIN
  snake_name = name.gsub(/(.)([A-Z])/,'\1_\2').downcase

  filename = "#{app_dir}/entities/#{snake_name}.rb"
  File.open(filename, 'w') {|f| f.write(output) }

  output = <<FIN
require_relative '../../entities/#{snake_name}'

describe #{name} do
#{method_specs}
end


FIN
  filename = "#{app_dir}/spec/entities/#{snake_name}_spec.rb"
  File.open(filename, 'w') {|f| f.write(output) }


  #puts output
end



jacks.each do |k, v|

  name = k.chomp('Jack').downcase

  method_specs = ''
  method_definitions = ''

  v.each do |method|

    method_definitions << "
  def #{method}_contract input
    input_shape = {}
    output_shape = {}
    call_method :#{method}_alias, input, input_shape, output_shape
  end
    "

    method_specs << "
  describe '.#{method}_contract' do
    it 'should #{method} data with valid input'

    it 'should raise an error with invalid input'

    it 'should raise an error with invalid output'

  end
    "

  end


  output = <<FIN
require 'obvious'

class #{k}Contract < Contract
  def self.contracts
    #{v.to_s}
  end
#{method_definitions}
end
FIN

  snake_name = name.gsub(/(.)([A-Z])/,'\1_\2').downcase

  filename = "#{app_dir}/contracts/#{snake_name}_jack_contract.rb"
  File.open(filename, 'w') {|f| f.write(output) }

  #puts output

  output = <<FIN
require_relative '../../contracts/#{snake_name}_jack_contract'

describe #{k}Contract do
#{method_specs}
end

FIN

  filename = "#{app_dir}/spec/contracts/#{snake_name}_jack_contract_spec.rb"
  File.open(filename, 'w') {|f| f.write(output) }

  #puts output
end




  end
end
