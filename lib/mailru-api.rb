#:encoding: utf-8

require 'mailru-api/error'
require 'mailru-api/request'
require 'mailru-api/audio'
require 'mailru-api/events'
require 'mailru-api/friends'
require 'mailru-api/guestbook'
require 'mailru-api/mail'
require 'mailru-api/mobile'
require 'mailru-api/notifications'
require 'mailru-api/photos'
require 'mailru-api/stream'
require 'mailru-api/users'

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
      return Audio.new(self)
    end
    
    def events
      return Events.new(self)
    end
    
    def friends
      return Friends.new(self)
    end
    
    def guestbook
      return Guestbook.new(self)
    end
    
    def mail
      return Mail.new(self)
    end
    
    def messages
      return Messages.new(self)
    end
    
    def mobile
      return Mobile.new(self)
    end
    
    def notifications
      return Notifications.new(self)
    end

    def photos
      return Photos.new(self)
    end
    
    def stream
      return Stream.new(self)
    end
    
    def users
      return Users.new(self)
    end
  end
end
