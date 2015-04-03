# PowerConverter

A placeholder for implementing a conversion module pattern.

Exposing a means of registering conversions. These can be accessed at the module
level:

```ruby
PowerConverter.conversion_for :boolean do |input|
  case input
  when false, 0, '0', 'false', 'no', nil then false
  else
    true
  end
end

PowerConverter.convert(object, to: :boolean)
```
