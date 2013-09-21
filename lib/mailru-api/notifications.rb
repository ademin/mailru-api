#:encoding: utf-8

module MailRU
  class API
    class Notifications
      def initialize api
        @api = api
      end

      def send params = {}
        GetRequest.new(@api, 'notifications.send', params, Request::Secure::Yes).get
      end
    end
  end
end
