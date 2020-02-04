# frozen_string_literal: true

require_relative "rule"

module See5
  # Read See5 rules output and return an array of hashes representing the rules
  # Note that this is the output normally sent to stdout, NOT the .rules file!
  # The .rules file lacks some important information like confidence.
  class RulesFileParser
    def self.parse_file(fname)
      new(fname).model
    end

    def initialize(fname)
      @file = File.open(fname)
      @rules = []

      parse_file
    end

    def model
      {
        default_classification: @default_classification,
        rules: @rules
      }
    end

    def parse_file
      discard_header

      while (line = lines.next)
        if line.start_with?("Rule ")
          @rules << parse_rule(line)
        elsif line.start_with?("Default class:")
          @default_classification = line.split(":").last.strip

          break
        end
      end
    end

    private

    def lines
      # TODO: lazy unnecessary given that rules are small?
      @file.each_line.lazy
    end

    # Discard the file header and advance to the rules section
    # TODO: save the data from the header, in case user wants it?
    def discard_header
      while (line = lines.next)
        break if line == "Rules:\n"
      end
      # discard the final blank line
      lines.next
    end

    def parse_rule(line)
      rule_info = parse_rule_info_line(line)
      conditions = []

      while (line = lines.next.strip)
        if line.start_with?("->")
          class_info = parse_class_line(line)

          break
        end

        conditions << parse_condition_line(line)
      end

      Rule.new(rule_info, conditions.to_h, class_info)
    end

    def parse_class_line(line)
      matches = line.match(/class ([\w]+)  \[(.+)\]/)

      {
        classification: matches[1],
        confidence: matches[2].to_f
      }
    end

    def parse_rule_info_line(line)
      matches = line.match(%r{Rule \d+: \((\d+)(?:/)?([^,]*), lift (.+)\)})

      {
        cases_covered: matches[1].to_i,
        cases_not_covered: matches[2]&.to_i,
        lift: matches[3].to_f
      }
    end

    def parse_condition_line(line)
      (attr, val) = line.split("=").map(&:strip)

      [attr.to_sym, val]
    end
  end
end
