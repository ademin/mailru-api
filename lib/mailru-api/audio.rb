#:encoding: utf-8

module MailRU
  class API
    class Audio
      def initialize api
        @api = api
      end

      def get params = {}
        GetRequest.new(@api, 'audio.get', params).get
      end

      def link params = {}
        GetRequest.new(@api, 'audio.link', params).get
      end

      def search params = {}
        GetRequest.new(@api, 'audio.search', params).get
      end
    end
  end
end
