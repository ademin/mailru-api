#:encoding: utf-8

module MailRU
  class API
    class Friends
      RETURN_OBJECTS = 1
      RETURN_UIDS = 0

      def initialize api
        @api = api
      end

      def get params = {}
        GetRequest.new(@api, 'friends.get', params).get
      end

      def get_app_users params = {}
        GetRequest.new(@api, 'friends.getAppUsers', params).get
      end

      def get_invitations_count params = {}
        GetRequest.new(@api, 'friends.getInvitationsCount', params).get
      end

      def get_online params = {}
        GetRequest.new(@api, 'friends.getOnline', params).get
      end
    end
  end
end

