require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))
require 'power_converter'

PowerConverter.define_conversion_for :boolean do |input|
  case input
  when false, 0, '0', 'false', 'no', nil then false
  else
    true
  end
end

class TestPowerConverter < Minitest::Test
  [
    ['0', false, :boolean],
    ['false', false, :boolean],
    ['no', false, :boolean],
    [0, false, :boolean],
    [false, false, :boolean],
    [nil, false, :boolean],
    [1, true, :boolean],
    ['true', true, :boolean]
  ].each_with_index do |(actual, expected, conversion), index|
    define_method "test_conversion_scenario_#{index}" do
      assert_equal expected, PowerConverter.convert(actual, to: conversion)
    end
  end

  def test_raises_error_when_conversion_is_not_defined
    assert_raises(PowerConverter::ConverterNotFoundError) do
      PowerConverter.convert(true, to: :never)
    end
  end

  def test_power_converter_implements_convert_to_named_conversion_method
    assert_equal true, PowerConverter.convert_to_boolean('true')
  end

  def test_power_converter_gracefully_escalates_method_missing
    assert_raises(NoMethodError) { PowerConverter.borked }
  end

  def test_power_converter_responds_to_convert_to_named_conversion_method
    assert_equal true, PowerConverter.respond_to?(:convert_to_boolean, true)
  end

  def test_power_converter_gracefully_escalates_respond_to_missing
    assert_equal(false, PowerConverter.respond_to?(:borked))
  end

  def setup
    @object = Class.new do
      include PowerConverter.module_for(:boolean)
      def wraps_conversion(value)
        convert_to_boolean(value)
      end
    end.new
  end

  def test_mixed_in_conversion_method_is_private
    assert_raises(NoMethodError) do
      @object.convert_to_boolean
    end
  end

  def test_mixed_in_conversion_method_can_be_used
    assert_equal(true, @object.wraps_conversion('1'))
  end

  PowerConverter.define_conversion_for :foo do |input|
    input.foo if input.respond_to?(:foo)
  end

  def test_conversion_method_raises_an_error_if_nil_is_returned
    assert_raises(PowerConverter::ConversionError) do
      PowerConverter.convert(true, to: :foo)
    end
  end

  def test_conversion_method_leverages_conversion_via_a_to_method
    struct = Struct.new(:to_foo)
    object = struct.new(123)
    assert_equal(object.to_foo, PowerConverter.convert(object, to: :foo))
  end

  def test_conversion_method_skips_any_private_to_method
    struct = Struct.new(:to_foo)
    struct.send(:private, :to_foo)
    object = struct.new(123)
    assert_raises(PowerConverter::ConversionError) do
      PowerConverter.convert(object, to: :foo)
    end
  end
end
