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
    def initialize(named_converter, registered_converter_names)
      super("Unable to find PowerConverter for #{named_converter} in #{registered_converter_names.inspect}")
    end
  end

  module_function

  # @api public
  # @since 0.0.1
  def define_conversion_for(name, &converter)
    @conversions ||= {}
    @conversions[name.to_s] = converter
  end

  # @api public
  # @since 0.0.1
  def convert(value, options = {})
    converter_for(options.fetch(:to)).call(value)
  end

  # @api public
  # @since 0.0.1
  def module_for(named_conversion)
    converter = converter_for(named_conversion)
    Module.new do
      define_method("convert_to_#{named_conversion}", &converter)
      private "convert_to_#{named_conversion}"
    end
  end

  # @api public
  # @since 0.0.1
  def converter_for(to)
    @conversions.fetch(to.to_s)
  rescue KeyError
    raise ConverterNotFoundError.new(named_conversion, registered_converter_names)
  end

  # @api public
  # @since 0.0.1
  def registered_converter_names
    @conversions.keys
  end
end
