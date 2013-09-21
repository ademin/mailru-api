#:encoding: utf-8

module MailRU
	class API
    class Mail
      def initialize api
        @api = api
      end

      def get_unread_count params = {}
        GetRequest.new(@api, 'mail.getUnreadCount', params).get
      end
    end
	end
end
