require "power_converter/version"

# PowerConverter is a composition service module. It provides a way to define
# conversion methods.
#
# What is a conversion method?
#
# > A well-established Ruby idiom for methods which "do the right thing" to
# > convery any reasonable input value into a desired class.
# >
# > http://devblog.avdi.org/2012/05/07/a-ruby-conversion-idiom/
#
# Why conversion methods?
#
# Because software is all about addressing a mapping problem. In my experience
# it has also exposed a means for easing the movement across application design
# boundaries.
module PowerConverter
  # When you tried to find a named_converter and it did not exist, this is a
  # reasonable exception to expect.
  class ConverterNotFoundError < RuntimeError
    # @param named_converter [#to_s]
    # @param defined_converter_names [Array]
    #
    # @example
    #   raise ConverterNotFoundError.new(:boolean, [:hello, :world])
    def initialize(named_converter, defined_converter_names)
      super("Unable to find PowerConverter for #{named_converter} in #{defined_converter_names.inspect}")
    end
  end

  # When you tried to convert something and it just won't convert, this is a
  # great exception to raise.
  class ConversionError < RuntimeError
    # @param value [Object]
    # @param named_converter [#to_s]
    #
    # @example
    #   raise ConversionError.new(:boolean, [:hello, :world])
    def initialize(value, named_converter)
      super("Unable to convert #{value.inspect} to #{named_converter}")
    end
  end

  module_function

  # @api public
  # @since 0.0.1
  #
  # Responsible for defining a conversion method and a "shovel-ready" conversion
  # module; because maybe you want a mixin for convenience reasons.
  #
  # @note If your defined converter returns `nil`, it is assumed if the
  #   conversion failed and a [PowerConverter::ConversionError] exception should
  #   be thrown.
  #
  # @param named_conversion [String,Symbol] the name of the conversion that you
  #   are declaring.
  # @param converter [#call] the callable object that will perform the
  #   conversion.
  # @yield [value] A block that will be used to convert the given value
  #   to the named thing.
  # @yieldreturn returns the named thing.
  #
  # @return void
  #
  # @example
  #   PowerConverter.define_conversion_for :boolean do |input|
  #     case input
  #     when false, 0, '0', 'false', 'no', nil then false
  #     else
  #       true
  #     end
  #   end
  # @see http://devblog.avdi.org/2012/05/07/a-ruby-conversion-idiom/ Avdi
  #   Grimm's post on "A Ruby Conversion Idiom"
  #
  # @see Kernel#Array for inspiration
  #
  # @note The conversion module/method that is created may not adhear to the
  #   exact idiom (a method defined in CamelCase)
  #
  # @todo Make sure that the converter requires at least one parameter.
  def define_conversion_for(named_conversion, &converter)
    @defined_conversions ||= {}
    @defined_conversions[named_conversion.to_s] = converter
  end

  # @api public
  # @since 0.0.1
  #
  # Convert the given `value` via the named `:to` converter.
  #
  # @param value [Object] the thing that you will be converting
  # @param [Hash] options the options used to perform the conversion
  # @option options [Symbol] :to the named_conversion that has been registered
  #
  # @return [Object] the resulting converted object
  #
  # @raise [ConverterNotFoundError] if the named converter is not found
  # @raise [ConversionError] if the named converter returned a nil value
  #
  # @see PowerConverter.define_conversion_for
  #
  # @example
  #   PowerConverter.convert('true', to: :boolean)
  #
  # @todo I want to:
  #   * auto-handle :to_<named_conversion> so I don't need to worry about
  #     registering that.
  def convert(value, options = {})
    named_converter = options.fetch(:to)
    returning_value = converter_for(named_converter).call(value)
    if returning_value.nil?
      fail ConversionError.new(value, named_converter)
    else
      returning_value
    end
  end

  # @api public
  # @since 0.0.1
  #
  # The means for mixing in a private conversion method; Perhaps as policy you
  # don't want to expose the public conversion method but instead prefer to
  # leverage private methods.
  #
  # @param named_conversion [String,Symbol] the name of the conversion that you
  #   are requesting be wrapped in a conversion module.
  #
  # @return [Module] a conversion module to use for mixing in behavior
  #
  # @example
  #   class Foo
  #     attr_accessor :bar
  #     include PowerConverter.module_for(:boolean)
  #     def bar_as_boolean
  #       convert_to_boolean(@bar)
  #     end
  #   end
  #
  # @todo Make sure I'm adhearing to the same interface as the .convert method.
  # @todo Allow for the inclusion of multiple power converter named types.
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
  # Given the `named_conversion` find and retrieve the defined converter.
  #
  # @param named_conversion [String,Symbol]
  #
  # @return [#call] a registered converter
  #
  # @raise [ConverterNotFoundError] if the named converter is not found
  #
  # @see PowerConverter.define_conversion_for
  #
  # @example
  #   PowerConverter.converter_for(:boolean).call(value)
  def converter_for(named_conversion)
    @defined_conversions.fetch(named_conversion.to_s)
  rescue KeyError
    raise ConverterNotFoundError.new(named_conversion, defined_converter_names)
  end

  # @api public
  # @since 0.0.1
  #
  # A convenience method for seeing the names of all converters that have been
  # defined.
  #
  # @return [Array] of the registered converter's names
  def defined_converter_names
    @defined_conversions.keys
  end
end
