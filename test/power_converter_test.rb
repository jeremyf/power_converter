require 'minitest/autorun'
$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))
require 'power_converter'

PowerConverter.conversion_for :boolean do |input|
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
    ['true', true, :boolean],
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
end
