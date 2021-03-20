# frozen_string_literal: true

require "json"

module See5
  class Model
    attr_reader :rules

    def initialize(default_classification:, rules:)
      @default_classification = default_classification
      @rules = rules
    end

    def classify(data)
      # See5 orders rules by confidence within each class (TODO verify),
      # so the first matching rule is the one with the highest confidence.
      first_matching_rule = rules.find { |rule| rule.match?(data) }

      return first_matching_rule.classification unless first_matching_rule.nil?

      @default_classification
    end

    def to_h
      { default_classification: @default_classification,
        rules: rules.map(&:to_h) }
    end

    def to_json
      to_h.to_json
    end

    def self.from_json(json)
      json_hash = JSON.parse(json, symbolize_names: true)
      new(default_classification: json_hash[:default_classification],
          rules: json_hash[:rules]&.map { |rule_hash| Rule.from_h(rule_hash) })
    end
  end
end
