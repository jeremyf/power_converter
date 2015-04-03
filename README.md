# PowerConverter

[![Build Status](https://travis-ci.org/jeremyf/power_converter.png?branch=master)](https://travis-ci.org/jeremyf/power_converter)
[![Documentation Status](http://inch-ci.org/github/jeremyf/power_converter.svg?branch=master)](http://inch-ci.org/github/jeremyf/power_converter)
[![APACHE 2 License](http://img.shields.io/badge/APACHE2-license-blue.svg)](./LICENSE)

A placeholder for implementing a conversion module pattern.

Exposing a means of registering conversions. These can be accessed at the module
level:

```ruby
PowerConverter.define_conversion_for :boolean do |input|
  case input
  when false, 0, '0', 'false', 'no', nil then false
  else
    true
  end
end

PowerConverter.convert(object, to: :boolean)
```
