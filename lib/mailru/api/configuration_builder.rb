module MailRU
  class API
    class ConfigurationBuilder
      attr_reader :configuration

      def initialize(&block)
        @configuration = {}
        instance_eval(&block) if block_given?
      end

      PARAMS.each do |param|
        class_eval <<-EOV, __FILE__, __LINE__ + 1
          def #{param}(value)                  # def app_id(value)
            @configuration[:#{param}] = value  #   @configuration[:app_id] = value
          end                                  # end
        EOV
      end
    end
  end
end
