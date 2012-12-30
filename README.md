# Obvious

Obvious is an architecture framework. The goal is to provide architectural structure for a highly testable system that is 
obvious to understand and where both the front end UI and back end infrastructure are treated as implementation details 
independent of the app logic itself.

You can get a full explanation of Obvious at http://obvious.retromocha.com

## Installation

Add this line to your application's Gemfile:

    gem 'obvious'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install obvious

## Usage

Obvious is designed to be used in two ways - as a gem you require in your Obvious projects and also as an Obvious project 
generation tool. 

The project generation tool is run by executing...

    $ obvious generate 

in a directory containing a decriptors directory. You can read more about descriptors on the Obvious page or see an example
in the Obvious Status example app: https://github.com/RetroMocha/obvious_status. 

Currently the footprint of the Obvious library is quite small. The most important things defined so far are the Contract class
and the Hash.has_shape? method. The rest of what makes an Obvious app interesting is the structure itself, not the libraries Obvious
provides.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
