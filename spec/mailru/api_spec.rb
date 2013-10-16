require 'spec_helper'

module MailRU
  describe API do
    subject do
      class API::GetRequest; def get; self; end; end
      class API::PostRequest; def post; self; end; end
      API.new
    end

    API::PARAMS.inject({}){ |params, param| params.merge({param => (0...12).map{ (65 + rand(26)).chr }.join}) }.each do |param, value|
      it "should respond to #{param}" do
        subject.should respond_to(param)
      end

      it "should respond to #{param}=" do
        subject.should respond_to("#{param}=")
      end

      it "might be initialized with parameter #{param} set to #{value} through a block" do
        API.new do
          send(param, value)
        end.send(param).should eq(value)
      end

      it "might be initialized with parameter #{param} set to #{value} through a configuration parameter in a block" do
        API.new do |configuration|
          configuration.send("#{param}=", value)
        end.send(param).should eq(value)
      end

      it "might be initialized with parameter #{param} set to #{value} through parameters of the constructor" do
        API.new({param => value}).send(param).should eq(value)
      end

      it "might be initialized with a combination of
          parameter #{param} set to #{value} ghrough parameters of the constructor and
          parameter #{param} set to '123456' in a block" do
        API.new({param => value}) do
          send(param, '123456')
        end.send(param).should eq('123456')
      end

      it 'might be initialized through attributes assignments' do
        api = API.new
        api.send("#{param}=", value)
        api.send(param).should eq(value)
      end
    end

    context 'get' do
      it 'should respond to get method' do
        subject.should respond_to(:get)
      end
    end

    context 'post' do
      it 'should respond to post method' do
        subject.should respond_to(:post)
      end
    end

    context 'audio' do
      it %q(should respond to the audio's apis) do
        subject.should respond_to(:audio)
        subject.audio.should respond_to(:get)
        subject.audio.should respond_to(:link)
        subject.audio.should respond_to(:search)
      end
    end

    context 'events' do
      it %q(should respond to the events' apis) do
        subject.should respond_to(:events)
        subject.events.should respond_to(:get_new_count)
      end
    end

    context 'friends' do
      it %q(should respond to the friends' apis) do
        subject.should respond_to(:friends)
        subject.friends.should respond_to(:get)
        subject.friends.should respond_to(:get_app_users)
        subject.friends.should respond_to(:get_invitations_count)
        subject.friends.should respond_to(:get_online)
      end
    end

    context 'guestbook' do
      it %q(should respond to the guestbook's apis) do
        subject.should respond_to(:guestbook)
        subject.guestbook.should respond_to(:get)
        subject.guestbook.should respond_to(:post)
      end

      it %q(should use HTTP POST for the post api) do
        subject.guestbook.post.class.should eq(API::PostRequest)
      end
    end

    context 'mail' do
      it %q(should respond to the mail's apis) do
        subject.should respond_to(:mail)
        subject.mail.should respond_to(:get_unread_count)
      end
    end

    context 'messages' do
      it %q(should respond to the messages' apis) do
        subject.should respond_to(:messages)
        subject.messages.should respond_to(:get_thread)
        subject.messages.should respond_to(:get_threads_list)
        subject.messages.should respond_to(:get_unread_count)
        subject.messages.should respond_to(:post)
      end

      it %q(should use HTTP POST for the post api) do
        subject.messages.post.class.should eq(API::PostRequest)
      end
    end

    context 'mobile' do
      it %q(should respond to the mobile's apis) do
        subject.should respond_to(:mobile)
        subject.mobile.should respond_to(:get_canvas)
      end

      it %q(should force to use client-server schema for get_canvas api) do
        subject.mobile.get_canvas.instance_variable_get('@secure').should eq(API::Request::Secure::No)
      end
    end

    context 'notifications' do
      it %q(should respond to the notifications' apis) do
        subject.should respond_to(:notifications)
        subject.notifications.should respond_to(:send)
      end

      it %q(should force to use server-server schema for the send api) do
        subject.notifications.send.instance_variable_get('@secure').should eq(API::Request::Secure::Yes)
      end
    end

    context 'photos' do
      it %q(should respond to the photos' apis) do
        subject.should respond_to(:photos)
        subject.photos.should respond_to(:create_album)
        subject.photos.should respond_to(:get)
        subject.photos.should respond_to(:get_albums)
        subject.photos.should respond_to(:upload)
      end

      it %q(should use HTTP POST for the upload api) do
        subject.photos.upload.class.should eq(API::PostRequest)
      end
    end

    context 'stream' do
      it %q(should respond to the stream's apis) do
        subject.should respond_to(:stream)
        subject.stream.should respond_to(:comment)
        subject.stream.should respond_to(:get)
        subject.stream.should respond_to(:get_by_author)
        subject.stream.should respond_to(:like)
        subject.stream.should respond_to(:post)
        subject.stream.should respond_to(:share)
        subject.stream.should respond_to(:unlike)
      end

      it %q(should use HTTP POST for the post & share apis) do
        subject.stream.post.class.should eq(API::PostRequest)
        subject.stream.share.class.should eq(API::PostRequest)
      end
    end

    context 'users' do
      it %q(should respond to the users' apis) do
        subject.should respond_to(:users)
        subject.users.should respond_to(:get_balance)
        subject.users.should respond_to(:get_info)
        subject.users.should respond_to(:has_app_permission)
        subject.users.should respond_to(:is_app_user)
      end
    end
  end
end
