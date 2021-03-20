# frozen_string_literal: true

require "see5/input_file_writer"
require "see5/model"
require "see5/rules_output_parser"
require "see5/gritbot_output_parser"
require "see5/schema"
require "see5/version"

module See5
  def self.train(data, class_attribute:)
    prepare_tmp_files(data, class_attribute: class_attribute)
    run_see5

    output = See5::RulesOutputParser.parse_file("/tmp/ruby-see5.rules_output")

    See5::Model.new(**output)
  end

  def self.audit(data, class_attribute:)
    prepare_tmp_files(data, class_attribute: class_attribute)
    run_gritbot

    See5::GritbotOutputParser.parse_file("/tmp/ruby-see5.gritbot_output")
  end

  def self.prepare_tmp_files(data, class_attribute:)
    schema = See5::Schema.from_dataset(data, class_attribute: class_attribute)
    See5::InputFileWriter.write_files(data: data, schema: schema)
  end

  def self.run_see5
    system("c5.0 -f /tmp/ruby-see5 -r > /tmp/ruby-see5.rules_output")
  end

  def self.run_gritbot
    system("gritbot -s -f /tmp/ruby-see5 -r > /tmp/ruby-see5.gritbot_output")
  end
end
