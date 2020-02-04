# frozen_string_literal: true

require_relative "test_helper"

class TestRule < Minitest::Test
  def setup
    @rule = See5::Rule.new(
      { cases_covered: 5, cases_not_covered: 1, lift: 1.2 },
      { "a-nature": true, "b-nature": false },
      { classification: "a", confidence: 0.97 }
    )
  end

  def test_attributes
    assert_equal(
      { cases_covered: 5, cases_not_covered: 1, lift: 1.2 }, @rule.rule_info
    )
    assert_equal("a", @rule.classification)
    assert_equal(0.97, @rule.confidence)
  end

  def test_match
    assert_equal(true, @rule.match?("a-nature": true, "b-nature": false))
  end

  def test_no_match
    assert_equal(false, @rule.match?("a-nature": false, "b-nature": true))
  end

  def test_to_s
    assert_equal(
      "#<See5::Rule, @classification=a, @conditions={:\"a-nature\"=>true, :\"b-nature\"=>false}>",
      @rule.to_s
    )
  end
end
