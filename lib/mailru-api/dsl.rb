#:encoding: utf-8

module MailRU
  class API
    class DSL
      def initialize api, group,  &block
        @api = api
        @group = group
        if block_given?
          instance_eval(&block)
        end
      end

      def api name, method = :get
        self.class.send(:define_method, underscore(name)) do |params = {}|
          return GetRequest.new(@api, "#{@group}.#{name}", params).get if method == :get
          return PostRequest.new(@api, "#{@group}.#{name}", params).post if method == :post
          raise Error.create(0, 'Internal Error: HTTP method must be GET or POST!')
        end
      end

      private

      def underscore s
        s.gsub(/::/, '/').
          gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
          gsub(/([a-z\d])([A-Z])/,'\1_\2').
          tr("-", "_").
          downcase
      end
    end
  end
end
