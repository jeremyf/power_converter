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
  #
  # @param named_conversion [String,Symbol] the name of the conversion that you
  #   are declaring.
  # @yield [value] A block that will be used to convert the given value
  #   to the named thing.
  # @yieldreturn returns the named thing.
  def define_conversion_for(named_conversion, &converter)
    @conversions ||= {}
    @conversions[named_conversion.to_s] = converter
  end

  # @api public
  # @since 0.0.1
  #
  # @param value [Object] the thing that you will be converting
  # @param [Hash] options the options used to perform the conversion
  # @option options [Symbol] :to the named_conversion that has been registered
  #
  # @raise [ConverterNotFoundError] if the named converter is not found
  #
  # @see PowerConverter.define_conversion_for
  def convert(value, options = {})
    converter_for(options.fetch(:to)).call(value)
  end

  # @api public
  # @since 0.0.1
  #
  # @param named_conversion [String,Symbol] the name of the conversion that you
  #   are requesting be wrapped in a conversion module.
  #
  # @return [Module] a conversion module to use for mixing in behavior
  def module_for(named_conversion)
    converter = converter_for(named_conversion)
    Module.new do
      define_method("convert_to_#{named_conversion}", &converter)
      private "convert_to_#{named_conversion}"
    end
  end

  # @api public
  # @since 0.0.1
  #
  # @param named_conversion [String,Symbol]
  #
  # @return [#call] a registered converter
  #
  # @raise [ConverterNotFoundError] if the named converter is not found
  #
  # @see PowerConverter.define_conversion_for
  def converter_for(named_conversion)
    @conversions.fetch(named_conversion.to_s)
  rescue KeyError
    raise ConverterNotFoundError.new(named_conversion, registered_converter_names)
  end

  # @api public
  # @since 0.0.1
  #
  # @return [Array] of the registered converter's names
  def registered_converter_names
    @conversions.keys
  end
end
