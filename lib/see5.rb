# frozen_string_literal: true

require "see5/input_file_writer"
require "see5/model"
require "see5/rules_file_parser"
require "see5/schema"
require "see5/version"

module See5
  def self.train(data, class_attribute)
    schema = See5::Schema.from_dataset(data, class_attribute)
    See5::InputFileWriter.write_files(data: data, schema: schema)

    run_see5

    output = See5::RulesFileParser.parse_file("/tmp/ruby-see5.rules_output")

    See5::Model.new(**output)
  end

  def self.run_see5
    system("c5.0 -f /tmp/ruby-see5 -r > /tmp/ruby-see5.rules_output")
  end
end
