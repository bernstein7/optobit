module Optobit
  module Field
    module ClassMethods
      def has_options_field(field_name, with_values: [])
        @options_fields[field_name] = FieldDefinition.new(field_name, with_values)
        define_setter_for(name: field_name, values: with_values)
        define_proxy_getter_for(field_name)
      end

      def find_field_definition(field_name)
        @options_fields[field_name]
      end

      def available_options_for_field(field_name)
        find_field_definition(field_name).available_options
      end

      def define_setter_for(name:, values:)
        define_method("#{name}_map") do

        end
      end

      def define_proxy_getter_for(field_name)
        field_options_name = field_name.to_s.pluralize

        define_method(field_options_name) do
          value = instance_variable_get("@#{field_options_name}")
          return value if value

          value = begin
            indexes = options_map_for(field_name)
                      .each_with_index.reduce([]) do |array, (val, index)|
                        if val.zero?
                          array
                        else
                          array << index
                        end
                      end

            OptionsProxy.new(
              self,
              self.class.find_field_definition(field_name),
              self.class.available_options_for_field(field_name).values_at(*indexes)
            )
          end

          instance_variable_set("@#{field_options_name}", value)
        end
      end
    end

    module InstanceMethods
      def options_map_for(field_name)
        attributes[field_name.to_s].to_s(2).split('').map(&:to_i)
      end

      def existing_roles_map
        role.to_s(2).split('').map(&:to_i)
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods

      receiver.class_eval do
        @options_fields = {}
      end
    end
  end
end
