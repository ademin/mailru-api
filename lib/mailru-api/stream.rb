#:encoding: utf-8

module MailRU
	class API
    class Stream
      def initialize api
        @api = api
      end

      def comment params = {}
        GetRequest.new(@api, 'stream.comment', params).get
      end
      
      def get params = {}
        GetRequest.new(@api, 'stream.get', params).get
      end
      
      def get_by_author params = {}
        GetRequest.new(@api, 'stream.getByAuthor', params).get
      end
      
      def like params = {}
        GetRequest.new(@api, 'stream.like', params).get
      end

      def post params = {}
        PostRequest.new(@api, 'stream.post', params).post
      end

      def share params ={}
        PostRequest.new(@api, 'stream.share', params).post
      end
      
      def unlike params = {}
        GetRequest.new(@api, 'stream.unlike', params).get
      end
    end
	end
end
