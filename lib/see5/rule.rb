# frozen_string_literal: true

module See5
  class Rule
    attr_reader :classification, :confidence, :rule_info, :conditions

    def initialize(rule_info, conditions, class_info)
      @rule_info = rule_info
      @conditions = conditions
      @classification = class_info[:classification]
      @confidence = class_info[:confidence]
    end

    def match?(data)
      conditions
        .map { |attr, val| data[attr] == val }
        .all? { |matched| matched == true }
    end

    def to_h
      { rule_info: rule_info,
        conditions: conditions,
        classification: classification,
        confidence: confidence }
    end

    def self.from_h(h)
      new(h[:rule_info],
          h[:conditions],
          { classification: h[:classification],
            confidence: h[:confidence] })
    end

    def to_s
      [
        "See5::Rule",
        "@classification=#{classification}",
        "@conditions=#{conditions}"
      ]
        .join(", ")
        .yield_self { |s| "#<#{s}>" }
    end
  end
end
