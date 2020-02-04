# frozen_string_literal: true

require_relative "test_helper"

class TestSchema < Minitest::Test
  def test_when_class_attr_is_nil
    schema = See5::Schema.new(
      classes: %w[a b c],
      attributes: { "a-nature": [true, false],
                    "b-nature": %w[high medium low] }
    )

    assert_equal(
      "class_attribute\n" \
        "a-nature: true,false\n" \
        "b-nature: high,medium,low\n" \
        "class_attribute: a,b,c",
      schema.names_file_contents
    )
  end

  def test_when_class_attr_is_not_in_attrs
    schema = See5::Schema.new(
      classes: %w[a b c],
      attributes: { "a-nature": [true, false],
                    "b-nature": %w[high medium low] },
      class_attribute: "breed"
    )

    assert_equal(
      "breed\n" \
        "a-nature: true,false\n" \
        "b-nature: high,medium,low\n" \
        "breed: a,b,c",
      schema.names_file_contents
    )
  end

  def test_when_class_attr_is_in_attrs
    schema = See5::Schema.new(
      classes: nil,
      attributes: { "a-nature": [true, false],
                    "b-nature": %w[high medium low],
                    "breed": %w[a b c] },
      class_attribute: "breed"
    )

    assert_equal(
      "breed\n" \
        "a-nature: true,false\n" \
        "b-nature: high,medium,low\n" \
        "breed: a,b,c",
      schema.names_file_contents
    )
  end
end
