module Optobit
  class OptionsProxy
    include Enumerable

    def initialize(model, field_definition, values)
      @model = model
      @field_definition = field_definition
      @values = values
    end

    def << value
      @values.push(value)
      update_model_attrbute

      @values
    end

    def delete(value)
      @values.delete(value)
      update_model_attrbute

      @values
    end

    def update_model_attrbute
      @model.public_send("#{@field_definition.field_name}=", to_i)
    end

    def each(&block)
      @values.each(&block)
    end

    def to_i
      binary_array = @field_definition.available_options.map do |available_option|
        @values.include?(available_option) ? 1 : 0
      end

      binary_array.join.to_i(2)
    end

    def inspect
      @values.inspect
    end
  end
end
