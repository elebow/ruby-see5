# frozen_string_literal: true

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
  end
end
