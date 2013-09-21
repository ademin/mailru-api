#:encoding: utf-8

module MailRU
	class API
    class Photos
      def initialize api
        @api = api
      end

      def create_album params = {}
        GetRequest.new(@api, 'photos.createAlbum', params).get
      end
      
      def get params = {}
        GetRequest.new(@api, 'photos.get', params).get
      end
      
      def get_albums params = {}
        GetRequest.new(@api, 'photos.getAlbums', params).get
      end

      def upload params = {}
        PostRequest.new(@api, 'photos.upload', params).post
      end
    end
	end
end
