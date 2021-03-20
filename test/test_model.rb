# frozen_string_literal: true

require_relative "test_helper"

class TestModel < Minitest::Test
  def setup
    @model = See5::Model.new(
      default_classification: "c",
      rules: [
        See5::Rule.new({},
                       { "a-nature": true, "b-nature": false },
                       { classification: "a" }),
        See5::Rule.new({},
                       { "a-nature": false, "b-nature": true },
                       { classification: "b" })
      ]
    )
  end

  def test_match_first_rule
    assert_equal("a", @model.classify("a-nature": true, "b-nature": false))
  end

  def test_match_second_rule
    assert_equal("b", @model.classify("a-nature": false, "b-nature": true))
  end

  def test_match_no_rules
    assert_equal("c", @model.classify("a-nature": false, "b-nature": false))
  end

  # TODO: test_match_multiple_rules

  def test_to_json
    assert_equal(
      "{\"default_classification\":\"c\",\"rules\":[{\"rule_info\":{},\"conditions\":{\"a-nature\":true,\"b-nature\":false},\"classification\":\"a\",\"confidence\":null},{\"rule_info\":{},\"conditions\":{\"a-nature\":false,\"b-nature\":true},\"classification\":\"b\",\"confidence\":null}]}",
      @model.to_json)
  end

  def test_from_json
    new_model = See5::Model.from_json("{\"default_classification\":\"c\",\"rules\":[{\"rule_info\":{},\"conditions\":{\"a-nature\":true,\"b-nature\":false},\"classification\":\"a\",\"confidence\":null},{\"rule_info\":{},\"conditions\":{\"a-nature\":false,\"b-nature\":true},\"classification\":\"b\",\"confidence\":null}]}")

    assert_equal(@model.to_h, new_model.to_h)
  end
end
