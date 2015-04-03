# PowerConverter

[![Gem Version](https://badge.fury.io/rb/power_converter.svg)](http://badge.fury.io/rb/power_converter)
[![Build Status](https://travis-ci.org/jeremyf/power_converter.png?branch=master)](https://travis-ci.org/jeremyf/power_converter)
[![Documentation Status](http://inch-ci.org/github/jeremyf/power_converter.svg?branch=master)](http://inch-ci.org/github/jeremyf/power_converter)
[![APACHE 2 License](http://img.shields.io/badge/APACHE2-license-blue.svg)](./LICENSE)

## About

**PowerConverter** exposes a means for defining a named conversion method.

*What is a conversion method?*

> A well-established Ruby idiom for methods which "do the right thing" to
> convery any reasonable input value into a desired class.
>
> http://devblog.avdi.org/2012/05/07/a-ruby-conversion-idiom/

*Why conversion methods?*

Because software is all about addressing a mapping problem. In my experience
using conversion methods has provided a means for easing the movement across
application design boundaries.

*Why use the PowerConverter gem?*

Excellent question.

**The short-answer is consistency**. **PowerConverter** helps you compose
conversions that have a common form.

**The longer-answer** is again related to consistency. By using a common
mechanism for definition, I'm hoping to reduce the nuanced variations that come
from crafting conversions. They all have a very similar shape, and I'd like to
provide tooling to help keep that shape.

I would much rather focus on other concepts than "is this conversion method
similar enough to its sibling conversion methods?"

In other words, relying on a common interface for defining a conversion method
reduces the number surprises when interacting with conversion methods.

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
