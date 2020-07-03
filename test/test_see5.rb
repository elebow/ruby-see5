# frozen_string_literal: true

require_relative "test_helper"

class TestSee5 < Minitest::Test
  def setup
    data = [
      { a: true, b: "high", breed: :one },
      { a: true, b: "high", breed: :one },
      { a: true, b: "low", breed: :two },
      { a: true, b: "low", breed: :two },
      { a: false, b: "medium", breed: :one },
      { a: false, b: "medium", breed: :one },
      { a: false, b: "low", breed: :two },
      { a: false, b: "low", breed: :two },
      { a: false, b: "low", breed: :two }
    ]

    @classifier = See5.train(data, class_attribute: :breed)
  end

  def test_classify
    assert_equal("one", @classifier.classify(b: "high"))
    assert_equal("one", @classifier.classify(b: "medium"))
    assert_equal("two", @classifier.classify(b: "low"))
  end
end
