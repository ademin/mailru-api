#:encoding: utf-8

require 'mailru-api/error'
require 'mailru-api/request'
require 'mailru-api/dsl'

module MailRU
  class APIConfiguration
    attr_accessor :app_id, :secret_key, :private_key, :session_key, :uid, :format
  end

  class APIConfigurationBuilder
    attr_reader :configuration

    def initialize(&block)
      if block_given?
        @configuration = APIConfiguration.new
        instance_eval(&block)
      end
    end

    def app_id value
      @configuration.app_id = value
    end

    def secret_key value
      @configuration.secret_key = value
    end

    def private_key value
      @configuration.private_key = value
    end

    def session_key value
      @configuration.session_key = value
    end

    def uid value
      @configuration.uid = value
    end

    def format value
      @configuration.format = value
    end
  end

  class API
    module Format
      XML = 'xml'
      JSON = 'json'
    end

    PATH = 'http://www.appsmail.ru/platform/api'

    attr_accessor :app_id, :secret_key, :private_key, :session_key, :uid, :format

    def initialize options = {}, &block
      @app_id = options[:app_id]
      @secret_key = options[:secret_key]
      @private_key = options[:private_key]
      @session_key = options[:session_key]
      @uid = options[:uid]
      @format = options[:format]

      if block_given?
        if block.arity == 1
          yield self
        else
          configuration = APIConfigurationBuilder.new(&block).configuration

          unless configuration.nil?
            @app_id = configuration.app_id || @app_id
            @secret_key = configuration.secret_key || @secret_key
            @private_key = configuration.private_key || @private_key
            @session_key = configuration.session_key || @session_key
            @uid = configuration.uid || @uid
            @format = configuration.format || @format
          end
        end
      end
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
