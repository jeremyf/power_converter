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
  def test_conversion_definition
    assert_equal false, PowerConverter.convert('0', to: :boolean)
  end
end
