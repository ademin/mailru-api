#:encoding: utf-8

module MailRU
  class API
    class Guestbook
      def initialize api
        @api = api
      end

      def get params = {}
        GetRequest.new(@api, 'guestbook.get', params).get
      end

      def post params = {}
        PostRequest.new(@api, 'guestbook.post', params).post
      end
    end
  end
end
