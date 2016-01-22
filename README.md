# PowerConverter

[![Gem Version](https://badge.fury.io/rb/power_converter.svg)](http://badge.fury.io/rb/power_converter)
[![Build Status](https://travis-ci.org/jeremyf/power_converter.png?branch=master)](https://travis-ci.org/jeremyf/power_converter)
[![Code Climate](https://codeclimate.com/github/jeremyf/power_converter/badges/gpa.svg)](https://codeclimate.com/github/jeremyf/power_converter)
[![Test Coverage](https://codeclimate.com/github/jeremyf/power_converter/badges/coverage.svg)](https://codeclimate.com/github/jeremyf/power_converter)
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

Name and define conversions via a block.

```ruby
PowerConverter.define_conversion_for(:always_true) { true }
PowerConverter.define_conversion_for(:always_nil) { nil }
PowerConverter.define_conversion_for(:boolean) { |value| !!value }
```

Call the conversions via a couple of methods:

```ruby
PowerConverter.convert(nil, to: :always_true)
# or
PowerConverter.convert_to_always_true(nil)
```

When you call a conversion, if the conversion block evaluates to `nil`, PowerConverter will fail with a `PowerConverter::ConversionError` exception.

```ruby
assert_raises(PowerConverter::ConversionError) { PowerConverter.convert(true, to: :always_nil) }
```

If you call the conversion and pass a block, the block will be the fallback for an evaluated `nil`.

```ruby
assert_equal('FALLBACK', PowerConverter.convert(true, to: :always_nil) { 'FALLBACK'} )
```

If the object you are attempting to convert responds to the `to_<conversion_name>` method, that method will be called.

```ruby
Thing = Struct.new(:to_always_nil)
thing = Thing.new("result of to_always_nil")
assert_equal("result of to_always_nil", PowerConverter.convert(thing, to: :always_nil))
```

You can also declare an alias for a registered `PowerConverter`.

```ruby
PowerConverter.define_alias(:true_or_false, is_alias_of: :boolean)
PowerConverter.convert("Hello", to: :boolean)
```

At times, a conversion may need additional information to be successful.

```ruby
PowerConverter.define_conversion_for(:user_action) do |input, user|
  case input
  when String, Symbol then user.actions.find_by(name: input)
  when Model::Action
    input.user == user ? input : nil
  end
end

PowerConverter.convert('start', to: :user_action, scope: a_user)
```

### TODO

* Write about module declaration
