#:encoding: utf-8

module MailRU
	class API
    class Users
      def initialize api
        @api = api
      end

      def get_balance
        GetRequest.new(@api, 'users.getBalance', params).get
      end
      
      def get_info params = {}
        GetRequest.new(@api, 'users.getInfo', params).get
      end
      
      def has_app_permission params = {}
        GetRequest.new(@api, 'users.hasAppPermission', params).get
      end
      
      def is_app_user
        GetRequest.new(@api, 'users.isAppUser', params).get
      end
    end
  end
end
