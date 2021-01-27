# frozen_string_literal: true

module See5
  # Read Gritbot output and return an array of hashes representing the anomalies
  class GritbotOutputParser
    attr_reader :anomalies

    def self.parse_file(fname)
      new(fname).anomalies
    end

    def initialize(fname)
      @file = File.open(fname)
      @anomalies = []

      parse_file
    end

    def parse_file
      discard_header

      while (line = lines.next)
        if line.start_with?(/\s*while checking/)
          # TODO record excluded cases
        elsif line.start_with?(/(:?test |data )?case /)
          @anomalies << parse_anomaly(line)
        elsif line.start_with?("Time:")
          break
        end
      end
    end

    private

    def lines
      # TODO: lazy unnecessary given that rules are small?
      @file.each_line.lazy
    end

    # Discard the file header and advance to the anomalies section
    def discard_header
      while (line = lines.next)
        break if line.start_with?(/\d+ possible anomal/)
      end
      # discard the final blank line
      lines.next
    end

    def parse_anomaly(line)
      info = parse_anomaly_info_line(line)
      value = parse_anomaly_value_line(lines.next)

      conditions = []
      while (line = lines.next.strip)
        break if line == ""

        conditions << parse_condition_line(line)
      end

      # TODO new class for these
      {
        **info,
        **value,
        conditions: conditions
      }
    end

    def parse_anomaly_info_line(line)
      matches = line.match(/.*case (.*): (.*)\[([\.\d]+)\]/)

      {
        case_index: matches[1],
        case_label: matches[2].strip.delete_prefix("(label ").delete_suffix(")"),
        signifigance: matches[3].to_f
      }
    end

    def parse_anomaly_value_line(line)
      matches = line.match(/(.*) = (\S*)\s*\((.*)\)/)

      {
        attribute: matches[1].strip,
        value: matches[2],
        reason: matches[3]
      }
    end

    def parse_condition_line(line)
      line.strip
    end
  end
end
