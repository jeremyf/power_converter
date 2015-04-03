require "power_converter/version"

# PowerConverter is a composition service module. It provides a way to define
# conversion methods.
#
# What is a conversion method?
#
# TODO: Define conversion method intent
module PowerConverter
  class ConverterNotFoundError < RuntimeError
    def initialize(to, named_converters)
      super("Unable to find PowerConverter for #{to} in #{named_converters}")
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
    raise ConverterNotFoundError.new(to, @conversions.keys.inspect)
  end
end
