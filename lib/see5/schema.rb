# frozen_string_literal: true

module See5
  class Schema
    attr_reader :class_attribute, :attributes

    def initialize(classes:, attributes:, class_attribute: nil)
      @classes = classes
      @attributes = attributes
      @class_attribute = class_attribute&.to_sym || :class_attribute

      # if the class attribute doesn't exist in the attributes, add it
      unless @attributes.key?(@class_attribute)
        @attributes[@class_attribute] = @classes
      end
    end

    def names_file_contents
      class_attribute.to_s + # TODO: continuous class attribute
        "\n" +
        attributes.map do |attr, vals|
          "#{attr}: #{vals.join(',')}"
        end.join("\n")
    end
  end
end
