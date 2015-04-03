require "power_converter/version"

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
    @conversions.fetch(to.to_s).call(value)
  rescue KeyError
    raise ConverterNotFoundError.new(to, @conversions.keys.inspect)
  end
end
