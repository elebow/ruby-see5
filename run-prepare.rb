# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("lib", __dir__)
require "see5"

class TestRecord
  attr_reader :a, :b, :breed

  def initialize(a, b, breed)
    @a = a
    @b = b
    @breed = breed
  end
end

data = [
  TestRecord.new(true, "medium", "a"),
  TestRecord.new(true, "low", "a"),
  TestRecord.new(false, "high", "b"),
  TestRecord.new(false, "medium", "b"),
  TestRecord.new(false, "low", "c")
]

schema = See5::Schema.new(
  classes: %w[a b c],
  attributes: { "a": [true, false],
                "b": %w[high medium low] },
  class_attribute: "breed"
)

See5::InputFileWriter.write_files(data: data, schema: schema)
