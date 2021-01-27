# frozen_string_literal: true

require_relative "test_helper"

class TestSee5 < Minitest::Test
  def test_classify
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

    classifier = See5.train(data, class_attribute: :breed)

    assert_equal("one", classifier.classify(b: "high"))
    assert_equal("one", classifier.classify(b: "medium"))
    assert_equal("two", classifier.classify(b: "low"))
  end

  def test_audit
    data = []
    1000.times { data.append({ a: 1, b: 1 }) }
    1000.times { data.append({ a: 2, b: 2 }) }
    data.append({ a: 2, b: 1 })

    anomaly = See5.audit(data, class_attribute: :b).first

    assert_equal(0.002, anomaly[:signifigance])
    assert_equal("b", anomaly[:attribute])
    assert_equal(["a = 2"], anomaly[:conditions])
  end
end
