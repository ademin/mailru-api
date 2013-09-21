#:encoding: utf-8
 
module MyMailRU
	class API
    class Messages
      def get_thread params = {}
        GetRequest.new(@api, 'messages.getThread', params).get
      end
      
      def get_threads_list params = {}
        GetRequest.new(@api, 'messages.getThreadsList', params).get
      end
      
      def get_unread_count params = {}
        GetRequest.new(@api, 'messages.getUnreadCount', params).get
      end

      def post params = {}
        PostRequest.new(@api, 'messages.post', params).post
      end
    end
	end
end
