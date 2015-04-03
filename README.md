# PowerConverter

[![Gem Version](https://badge.fury.io/rb/power_converter.svg)](http://badge.fury.io/rb/power_converter)
[![Build Status](https://travis-ci.org/jeremyf/power_converter.png?branch=master)](https://travis-ci.org/jeremyf/power_converter)
[![Documentation Status](http://inch-ci.org/github/jeremyf/power_converter.svg?branch=master)](http://inch-ci.org/github/jeremyf/power_converter)
[![APACHE 2 License](http://img.shields.io/badge/APACHE2-license-blue.svg)](./LICENSE)

## About

**PowerConverter** is a composition service module. It provides a way to define
conversion methods.

*What is a conversion method?*

> A well-established Ruby idiom for methods which "do the right thing" to
> convery any reasonable input value into a desired class.
>
> http://devblog.avdi.org/2012/05/07/a-ruby-conversion-idiom/

*Why conversion methods?*

Because software is all about addressing a mapping problem. In my experience
it has also exposed a means for easing the movement across application design
boundaries.

## Usage

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
