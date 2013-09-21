#:encoding: utf-8

module MailRU
	class API
    class Events
      def initialize api
        @api = api
      end

      def get_new_count
        GetRequest.new(@api, 'events.getNewCount', {}).get
      end
    end
	end
end
