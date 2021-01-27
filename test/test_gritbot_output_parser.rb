# frozen_string_literal: true

require_relative "test_helper"

class TestGritbotOutputParser < Minitest::Test
  def setup
    @anomalies = See5::GritbotOutputParser
                 .new("test/fixtures/mushroom.gritbot_output")
                 .anomalies
  end

  def test_anomalies
    assert_equal(5, @anomalies.count)

    first_anomaly = @anomalies.first
    assert_equal("1365", first_anomaly[:case_index])
    assert_equal("861", first_anomaly[:case_label])
    assert_equal(0.002, first_anomaly[:signifigance])
    assert_equal("age", first_anomaly[:attribute])
    assert_equal("455", first_anomaly[:value])
    assert_equal("3771 cases, mean 52, 99.97% <= 94", first_anomaly[:reason])
    assert_equal([], first_anomaly[:conditions])

    last_anomaly = @anomalies.last
    assert_equal("1610", last_anomaly[:case_index])
    assert_equal("3023", last_anomaly[:case_label])
    assert_equal(0.016, last_anomaly[:signifigance])
    assert_equal("age", last_anomaly[:attribute])
    assert_equal("73", last_anomaly[:value])
    assert_equal("53 cases, mean 32, 51 <= 42", last_anomaly[:reason])
    assert_equal(["pregnant = t"], last_anomaly[:conditions])
  end
end
