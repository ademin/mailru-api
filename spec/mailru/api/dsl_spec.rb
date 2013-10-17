require 'spec_helper'

module MailRU
  class API
    describe DSL do
      context 'api' do
        subject do
          class GetRequest; def get; self; end; end
          class PostRequest; def post; self; end; end

          DSL.new(API.new, 'group') do
            api 'send'
            api 'getMethod', :get
            api 'postMethod', :post
            api 'getSecureMethod', :get, Request::Secure::Yes
            api 'postInsecureMethod', :post, Request::Secure::No
          end
        end

        it %(should have singleton_methods: 'send', 'get_method', 'post_method', 'get_secure_method', 'post_insecure_method') do
          subject.singleton_methods.sort.should eq(
            [:send, :get_method, :post_method, :get_secure_method, :post_insecure_method].sort
          )
        end

        it %q(should have method 'send' which send any GET request) do
          subject.send.class.should eq(GetRequest)
          subject.send.instance_variable_get('@secure').should eq(Request::Secure::Any)
        end

        it %q(should have method 'get_method' which send any GET request) do
          subject.get_method.class.should eq(GetRequest)
          subject.get_method.instance_variable_get('@secure').should eq(Request::Secure::Any)
        end

        it %q(should have method 'post_method' which send any POST request) do
          subject.post_method.class.should eq(PostRequest)
          subject.post_method.instance_variable_get('@secure').should eq(Request::Secure::Any)
        end

        it %q(should have method 'get_secure_method' which send secure GET request) do
          subject.get_secure_method.class.should eq(GetRequest)
          subject.get_secure_method.instance_variable_get('@secure').should eq(Request::Secure::Yes)
        end

        it %q(should have method 'post_insecure_method' which send insecure POST request) do
          subject.post_insecure_method.class.should eq(PostRequest)
          subject.post_insecure_method.instance_variable_get('@secure').should eq(Request::Secure::No)
        end

        it %q(should raise an error when api's HTTP method is not set to GET or POST) do
          expect { DSL.new(API.new, 'group') {api 'error', :error} }.to raise_error(Error)
        end
      end

      context 'underscore' do
        subject do
          DSL.new(nil, nil)
        end

        it 'should return first_second_third for firstSecondThird' do
          subject.method(:underscore).call('firstSecondThird').should eq('first_second_third')
        end
      end
    end
  end
end
