require "power_converter/version"

# PowerConverter is a composition service module. It provides a way to define
# conversion methods.
#
# What is a conversion method?
#
# TODO: Define conversion method intent
module PowerConverter
  # When you tried to find a named_converter and it did not exist, this is a
  # reasonable exception to expect.
  class ConverterNotFoundError < RuntimeError
    def initialize(named_converter, named_converters)
      super("Unable to find PowerConverter for #{named_converter} in #{named_converters}")
    end
  end

  module_function
  def conversion_for(name, &block)
    @conversions ||= {}
    @conversions[name.to_s] = block
  end

  def convert(value, to:)
    converter_for(to).call(value)
  end

  def module_for(named_conversion)
    converter = converter_for(named_conversion)
    mod = Module.new do
      define_method("convert_to_#{named_conversion}", &converter)
      private "convert_to_#{named_conversion}"
    end
  end

  def converter_for(to)
    @conversions.fetch(to.to_s)
  rescue KeyError
    raise ConverterNotFoundError.new(to, named_converters)
  end

  def named_converters
    @conversions.keys.inspect
  end
end
