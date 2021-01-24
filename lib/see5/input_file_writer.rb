# frozen_string_literal: true

require_relative "schema"

module See5
  # Writes names and data files suitable for See5, Cubist, or GritBot.
  class InputFileWriter
    def self.write_files(data:, schema: nil, names_io: nil, data_io: nil)
      new(data: data, schema: schema, names_io: names_io, data_io: data_io)
        .write_files
    end

    def initialize(data:, schema: nil, names_io: nil, data_io: nil)
      @data = data
      @schema = schema # TODO: automatic schema from data objects' attributes
      @names_io = names_io
      @data_io = data_io
    end

    def write_files
      write_names_file
      write_data_file

      names_io.close
      data_io.close
    end

    def write_names_file
      names_io.write(@schema.names_file_contents)
    end

    def write_data_file
      # TODO: missing or N/A
      @data.each do |record|
        data_io.write(row(record))
        data_io.write("\n")
      end
    end

    private

    def row(record)
      @schema.attributes.map do |attr, _vals|
        if record.is_a?(Hash)
          record[attr]
        else
          # assume some kind of OpenStruct- or ActiveModel-like object
          record.send(attr)
        end
      end.join(",")
    end

    def names_io
      @names_io ||= File.open("/tmp/ruby-see5.names", "w")
    end

    def data_io
      @data_io ||= File.open("/tmp/ruby-see5.data", "w")
    end
  end
end
