#:encoding: utf-8

require 'json'
require 'net/http'
require 'uri'
require 'digest'
require 'rexml/document'

module MailRU
  class API
    class Request

      module Secure
        No = 0
        Yes = 1
        Any = 2
      end

      def initialize api, method, method_params, secure = Secure::Any
        @api = api
        @method = method
        @method_params = method_params
        @secure = secure
      end

      protected

      def use_s2s?
        @api.secret_key and (@secure == Secure::Yes or @secure == Secure::Any)
      end

      def use_c2s?
        @api.private_key and (@secure == Secure::No or @secure == Secure::Any) and @api.uid
      end

      def signature
        return s2s_signature if use_s2s?
        return c2s_signature if use_c2s?

        if @api.app_id.nil?
          raise Error.create(0, 'app_id must be specified.')
        end

        if @secure == Secure::Yes and @api.secret_key.nil?
          raise Error.create(0, 'secret_key must be specified for secure requests.')
        end

        if @secure == Secure::No and @api.private_key.nil?
          raise Error.create(0, 'private_key must be specified for non secure requests.')
        end

        if @secure == Secure::Any and @api.secret_key.nil? and @api.private_key.nil?
          raise Error.create(0, 'secret_key or private_key must be specified.')
        end

        if @secure == Secure::No and @api.uid.nil?
          raise Error.create(0, 'uid must be specified for non secure requests.')
        end

        if @secure == Secure::Any and @api.secret_key.nil? and @api.uid.nil?
          raise Error.create(0, 'uid must be specified for non secure requests.')
        end

        raise Error.create(0, 'unknown error.')
      end

      def c2s_signature
        Digest::MD5.hexdigest(@api.uid + parameters.sort.join + @api.private_key)
      end

      def s2s_signature
        Digest::MD5.hexdigest(parameters.sort.join + @api.secret_key)
      end

      def parameters
        params = {app_id: @api.app_id, method: @method}
        params.merge!({session_key: @api.session_key}) if @api.session_key
        params.merge!({format: @api.format}) if @api.format
        params.merge!({uid: @api.uid}) if use_c2s?
        params.merge!({secure: 1}) if use_s2s?

        params.merge!(@method_params) if @method_params

        params.to_a.map{|p| p.join('=')}
      end

      def handle_response response
        response = response.body unless response.is_a?(String)

        if @api.format == Format::XML
          response = REXML::Document.new(response).root

          error = response if response.name == 'error'
          if error
            raise Error.create(
              error.elements['error_code'].text,
              error.elements['error_msg'].text
            )
          end
        else
          response = JSON.parse(response)
          if response.is_a?(Hash)
            error = response['error']
            if error
              raise Error.create(error['error_code'], error['error_msg'])
            end
          end
        end

        response
      end
    end

    class GetRequest < Request   
      def get        
        request = URI.escape(PATH + '?' + parameters.push("sig=#{signature}").join('&'))
        handle_response(Net::HTTP.get(URI(request)))
      end
    end

    class PostRequest < Request
      def post
        uri = URI(PATH)
        request = Net::HTTP::Post.new(uri.path)
        request.body = parameters.push("sig=#{signature}").join('&')
        handle_response(Net::HTTP.new(uri.host, uri.port).request(request))
      end
    end
  end
end
