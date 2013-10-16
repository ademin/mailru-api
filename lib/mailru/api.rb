module MailRU
  class API
    PATH = 'http://www.appsmail.ru/platform/api'
    PARAMS = [:app_id, :secret_key, :private_key, :session_key, :uid, :format]

    def initialize options = {}, &block
      @configuration = options

      if block_given?
        if block.arity == 1
          yield self
        else
          @configuration.merge! ConfigurationBuilder.new(&block).configuration
        end
      end
    end

    PARAMS.each do |param|
      class_eval <<-EOV, __FILE__, __LINE__ + 1
        def #{param}=(value)                 # def app_id=(value)
          @configuration[:#{param}] = value  #   @configuration[:app_id] = value
        end                                  # end

        def #{param}                         # def app_id
          @configuration[:#{param}]          #   @configuration[:app_id]
        end                                  # end
      EOV
    end

    def get name, params = {}, secure = Request::Secure::Any
      GetRequest.new(self, name, params, secure).get
    end

    def post name, params = {}, secure = Request::Secure::Any
      PostRequest.new(self, name, params, secure).post
    end

    def audio
      DSL.new(self, 'audio') do
        api 'get'
        api 'link'
        api 'search'
      end
    end

    def events
      DSL.new(self, 'events') do
        api 'getNewCount'
      end
    end

    def friends
      DSL.new(self, 'friends') do
        api 'get'
        api 'getAppUsers'
        api 'getInvitationsCount'
        api 'getOnline'
      end
    end

    def guestbook
      DSL.new(self, 'guestbook') do
        api 'get'
        api 'post', :post
      end
    end

    def mail
      DSL.new(self, 'mail') do
        api 'getUnreadCount'
      end
    end

    def messages
      DSL.new(self, 'messages') do
        api 'getThread'
        api 'getThreadsList'
        api 'getUnreadCount'
        api 'post', :post
      end
    end

    def mobile
      DSL.new(self, 'mobile') do
        api 'getCanvas', :get, Request::Secure::No
      end
    end

    def notifications
      DSL.new(self, 'notifications') do
        api 'send', :get, Request::Secure::Yes
      end
    end

    def photos
      DSL.new(self, 'photos')  do
        api 'createAlbum'
        api 'get'
        api 'getAlbums'
        api 'upload', :post
      end
    end

    def stream
      DSL.new(self, 'stream') do
        api 'comment'
        api 'get'
        api 'getByAuthor'
        api 'like'
        api 'post', :post
        api 'share', :post
        api 'unlike'
      end
    end

    def users
      DSL.new(self, 'users') do
        api 'getBalance'
        api 'getInfo'
        api 'hasAppPermission'
        api 'isAppUser'
      end
    end
  end
end

require 'mailru/api/configuration_builder'
require 'mailru/api/dsl'
require 'mailru/api/error'
require 'mailru/api/format'
require 'mailru/api/request'
