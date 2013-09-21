#:encoding: utf-8

module MailRU
  class API
    class Mobile
      BASIC = 'basic'
      SMARTPHONE = 'smartphone'

      def initialize api
        @api = api
      end

      def get_canvas params = {}
        GetRequest.new(@api, 'mobile.getCanvas', params, Request::Secure::No).get
      end
    end
  end
end
