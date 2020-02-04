# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("lib", __dir__)
require "see5"

rules_file = See5::RulesFileParser
             .parse_file("test/fixtures/mushroom.rules_output")
model = See5::Model.new(
  default_classification: rules_file[:default_classification],
  rules: rules_file[:rules]
)

classification = model.classify(
  "odor" => "a",
  "spore-print-color" => "r"
)

puts classification
