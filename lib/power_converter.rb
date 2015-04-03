require "power_converter/version"

module PowerConverter
  module_function
  def conversion_for(name, &block)
    @conversions ||= {}
    @conversions[name] = block
  end

  def convert(value, to:)
    @conversions[to].call(value)
  end
end
