# frozen_string_literal: true

require_relative "test_helper"

class TestRulesOutputParser < Minitest::Test
  def setup
    @model = See5::RulesOutputParser
             .new("test/fixtures/mushroom.rules_output")
             .model
  end

  def test_default_classification
    assert_equal("e", @model[:default_classification])
  end

  def test_rules
    assert_equal(18, @model[:rules].count)

    first_rule = @model[:rules].first
    assert_equal("e", first_rule.classification)
    assert_equal({ "odor": "n", "spore-print-color": "k" }, first_rule.conditions)
    assert_equal(0.999, first_rule.confidence)
    assert_equal({ cases_covered: 1296, cases_not_covered: 0, lift: 1.9 }, first_rule.rule_info)

    last_rule = @model[:rules].last
    assert_equal("p", last_rule.classification)
    assert_equal({ "bruises?": "t", "odor": "n", "gill-size": "n" }, last_rule.conditions)
    assert_equal(0.9, last_rule.confidence)
    assert_equal({ cases_covered: 8, cases_not_covered: 0, lift: 1.9 }, last_rule.rule_info)
  end
end
