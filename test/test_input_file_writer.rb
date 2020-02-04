# frozen_string_literal: true

require_relative "test_helper"

class TestRecord
  attr_reader :a, :b, :breed

  def initialize(a, b, breed)
    @a = a
    @b = b
    @breed = breed
  end
end

class TestInputFileWriter < Minitest::Test
  def setup
    @schema = See5::Schema.new(
      classes: %w[a b c],
      attributes: { "a": [true, false],
                    "b": %w[high medium low] },
      class_attribute: "breed"
    )

    @data = [
      TestRecord.new(true, "medium", "a"),
      TestRecord.new(true, "low", "a"),
      TestRecord.new(false, "high", "b"),
      TestRecord.new(false, "medium", "b"),
      TestRecord.new(false, "low", "c")
    ]
  end

  def test_when_ios_are_passed_in
    names_io = StringIO.new
    data_io = StringIO.new

    writer = See5::InputFileWriter.new(data: @data,
                                       schema: @schema,
                                       names_io: names_io,
                                       data_io: data_io)
    writer.write_files

    assert_equal(
      "breed\n" \
        "a: true,false\n" \
        "b: high,medium,low\n" \
        "breed: a,b,c",
      names_io.string
    )

    assert_equal(
      "true,medium,a\n" \
        "true,low,a\n" \
        "false,high,b\n" \
        "false,medium,b\n" \
        "false,low,c\n",
      data_io.string
    )
  end

  def test_default_file_names
    writer = See5::InputFileWriter.new(data: @data,
                                       schema: @schema)

    assert_equal("/tmp/ruby-see5.names", writer.send(:names_io).path)
    assert_equal("/tmp/ruby-see5.data", writer.send(:data_io).path)
  end
end
