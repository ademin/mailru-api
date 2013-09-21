#:encoding: utf-8

module MailRU
  class API
    class Error < RuntimeError
      attr_accessor :code, :description

      def initialize code, description
        super("#{code}, #{description}")

        @code = Integer(code)
        @description = description
      end

      def self.create(code, description)
        case code
          when 1 then UnknwonError.new(code, description)
          when 2 then UnknownMethodCalledError.new(code, description)
          when 3 then MethodIsDeprecatedError.new(code, description)
          when 100 then InvalidParameterError.new(code, description)
          when 102 then AuthorizationFailedError.new(code, description)
          when 103 then ApplicationLookupFailedError.new(code, description)
          when 104 then IncorrectSignatureError.new(code, description)
          when 105 then ApplicationIsNotInstalledError.new(code, description)
          when 200 then PermissionDeniedError.new(code, description)
          when 202 then AccessToObjectDeniedError.new(code, description)
          when 501 then IncorrectImageError.new(code, description)
          else Error.new(code, "Internal Error: #{description}")
        end
      end
    end

    class UnknownError < Error; end
    class UnknownMethodCalledError < Error; end
    class MethodIsDeprecatedError < Error; end
    class InvalidParameterError < Error; end
    class AuthorizationFailedError < Error; end
    class ApplicationLookupFailedError < Error; end
    class IncorrectSignatureError < Error; end
    class ApplicationIsNotInstalledError < Error; end
    class PermissionDeniedError < Error; end
    class AccessToObjectDeniedError < Error; end
    class IncorrectImageError < Error; end
  end
end