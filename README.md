# loquendo-ruby

Easy-to-use API for interacting with Loquendo.io website. Remember, this is an unofficial Loquendo.io API client written in Ruby and may be taken down at any time. If you are the owner of the Loquendo.io website, please contact me!

## Installation

```bash
gem install loquendo-ruby
```

## Usage

```ruby
require 'loquendoruby'

speaker = LoquendoRuby::Main.new
speaker.set_voice('es-MX', 'Mia')
speaker.spech('hello world!')

```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/malvads/loquendo-ruby.



