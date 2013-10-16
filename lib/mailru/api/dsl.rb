module MailRU
  class API
    class DSL
      def initialize api, group,  &block
        @api = api
        @group = group
        instance_eval(&block) if block_given?
      end

      def api name, method = :get, secure = Request::Secure::Any
        raise Error.create(0, 'HTTP method must be GET or POST!') unless [:get, :post].include?(method)

        method(SEND).call(:define_singleton_method, underscore(name)) do |params = {}|
          return @api.get("#{@group}.#{name}", params, secure) if method == :get
          return @api.post("#{@group}.#{name}", params, secure) if method == :post
        end
      end

      private

      SEND = (0...6).map{ (65 + rand(26)).chr }.join
      alias_method(SEND, :send)

      def underscore s
        s.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
          gsub(/([a-z\d])([A-Z])/,'\1_\2').
          tr("-", "_").
          downcase
      end
    end
  end
end
