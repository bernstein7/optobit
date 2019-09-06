module Optobit
  class FieldDefinition
    attr_reader :available_options, :field_name

    def initialize(field_name, available_options)
      @field_name = field_name
      @available_options = available_options
    end
  end
end
