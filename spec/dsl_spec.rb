#:encoding: utf-8

require 'mailru-api'

module MailRU
  class API
    describe DSL do
      context 'api' do
        subject do
          class GetRequest; def get; self; end; end
          class PostRequest; def post; self; end; end

          DSL.new(nil, 'group') do
            api 'method'
            api 'getMethod', :get
            api 'postMethod', :post
            api 'getSecureMethod', :get, Request::Secure::Yes
            api 'postInsecureMethod', :post, Request::Secure::No
          end
        end

        it %(should have methods: 'method', 'get_method', 'post_method', 'get_secure_method', 'post_insecure_method']) do
          subject.should respond_to(:method)
          subject.should respond_to(:get_method)
          subject.should respond_to(:post_method)
          subject.should respond_to(:get_secure_method)
          subject.should respond_to(:post_insecure_method)
        end

        it %q(should have method 'method' which send any GET request) do
          subject.method.class.should eq(GetRequest)
          subject.method.instance_variable_get('@secure').should eq(Request::Secure::Any)
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
      end

      context 'underscore' do
        subject { DSL.new(nil, nil) }

        it 'should return first_second_third for firstSecondThird' do
          subject.send(:underscore, 'firstSecondThird').should eq('first_second_third')
        end
      end
    end
  end
end