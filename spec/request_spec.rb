#:encoding: utf-8

require 'mailru-api'
require 'webmock/rspec'

module MailRU
  class API
    describe Request do
      before(:each) do
        @api = API.new
      end

      context 'use_s2s?' do
        it 'should be true when secret_key is specified and secure set to Yes' do
          @api.secret_key = 'hidden'
          Request.new(@api, nil, nil, Request::Secure::Yes).send(:use_s2s?).should be_true
        end

        it 'should be true when secret_key is specified and secure set to Any' do
          @api.secret_key = 'hidden'
          Request.new(@api, nil, nil, Request::Secure::Any).send(:use_s2s?).should be_true
        end

        it 'should be false when secret_key is not specified' do
          Request.new(@api, nil, nil, Request::Secure::Yes).send(:use_s2s?).should be_false
        end

        it 'should be false when secure set to No' do
          @api.secret_key = 'hidden'
          Request.new(@api, nil, nil, Request::Secure::No).send(:use_s2s?).should be_false
        end
      end

      context 'use_c2s?' do
        it 'should be true private_key, uid are specified and secure set to No' do
          @api.private_key = 'hidden'
          @api.uid = 'hidden'
          Request.new(@api, nil, nil, Request::Secure::No).send(:use_c2s?).should be_true
        end

        it 'should be true when private_key, uid are specified and secure set to Any' do
          @api.private_key = 'hidden'
          @api.uid = 'hidden'
          Request.new(@api, nil, nil, Request::Secure::Any).send(:use_c2s?).should be_true
        end

        it 'should be false when private_key, uid are specified and secure set to Yes' do
          @api.private_key = 'hidden'
          @api.uid = 'hidden'
          Request.new(@api, nil, nil, Request::Secure::Yes).send(:use_c2s?).should be_false
        end

        it 'should be false when private_key is not specified but uid is specified and secure set to No' do
          @api.uid = 'hidden'
          Request.new(@api, nil, nil, Request::Secure::No).send(:use_c2s?).should be_false
        end

        it 'should be false when private_key is specified but uid is not specified and secure set to No' do
          @api.private_key = 'hidden'
          Request.new(@api, nil, nil, Request::Secure::No).send(:use_c2s?).should be_false
        end
      end

      context 's2s_signature' do
        it 'should not raise an error when secret_key is not specified' do
          expect { Request.new(@api, nil, nil).send(:s2s_signature) }.to_not raise_error
        end
      end

      context 'c2s_signature' do
        it 'should not raise an error when uid is not specified' do
          @api.private_key = 'hidden'
          expect { Request.new(@api, nil, nil).send(:c2s_signature)}.to_not raise_error
        end

        it 'should not raise an error when private_key is not specified' do
          @api.uid = 'hidden'
          expect { Request.new(@api, nil, nil).send(:c2s_signature)}.to_not raise_error
        end
      end

      context 'parameters' do
        before(:all) do
          @app_id = '123456'
          @method = 'stub'
          @secret_key = '234567890123456789'
          @private_key = '345678901234567890'
          @session_key = '2d5c59bd8b000b649502622dd99ffa6d'
          @uid = '123456789012345678'
          @method_params = {limit: 10, offset: 20}
        end

        it %Q(should contain app_id=#{@app_id}) do
          @api.app_id = @app_id
          Request.new(@api, nil, nil).send(:parameters).include?("app_id=#{@app_id}").should be_true
        end

        it %q(should not contain app_id parameter) do
          Request.new(@api, nil, nil).send(:parameters).select{|param| param.include?('app_id=')}.count.should eq(0)
        end

        it %Q(should contain method=#{@method}) do
          Request.new(@api, @method, nil).send(:parameters).include?("method=#{@method}").should be_true
        end

        it %q(should not contain method parameter) do
          Request.new(@api, nil, nil).send(:parameters).select{|param| param.include?('method=')}.count.should eq(0)
        end

        it %Q(should contain session_key=#{@session_key}) do
          @api.session_key = @session_key
          Request.new(@api, nil, nil).send(:parameters).include?("session_key=#{@session_key}").should be_true
        end

        it %q(should not contain session_key parameter) do
          Request.new(@api, nil, nil).send(:parameters).select{|param| param.include?('session_key=')}.count.should eq(0)
        end

        it %Q(should contain format=xml) do
          @api.format = Format::XML
          Request.new(@api, nil, nil).send(:parameters).include?("format=xml").should be_true
        end

        it %Q(should contain format=json) do
          @api.format = Format::JSON
          Request.new(@api, nil, nil).send(:parameters).include?("format=json").should be_true
        end

        it %q(should not contain format parameter) do
          Request.new(@api, nil, nil).send(:parameters).select{|param| param.include?('format=')}.count.should eq(0)
        end

        it %Q(should contain uid=#{@uid}) do
          @api.uid = @uid
          Request.new(@api, nil, nil).send(:parameters).include?("uid=#{@uid}").should be_true
        end

        it %q(should not contain app_id parameter) do
          Request.new(@api, nil, nil).send(:parameters).select{|param| param.include?('uid=')}.count.should eq(0)
        end

        it %Q(should contain secure=1) do
          @api.secret_key = @secret_key
          Request.new(@api, nil, nil).send(:parameters).include?("secure=1").should be_true
        end

        it %Q(should not contain secure=1) do
          @api.private_key = @private_key
          @api.uid = @uid
          Request.new(@api, nil, nil).send(:parameters).select{|param| param.include?("secure=1")}.count.should eq(0)
        end

        it %Q(should contain #{@method_params.to_a.map{|p| p.join('=')}}) do
          (Request.new(@api, nil, @method_params).send(:parameters) and @method_params.to_a.map{|p| p.join('=')}).should be_true
        end

        it %q(should not contain method_params parameter) do
          Request.new(@api, nil, nil).send(:parameters).join.should eq('')
        end
      end

      context 'handle_response' do
        context 'for XML' do
          before(:each) do
            @api = API.new
            @api.format = Format::XML

            @success_response = %q(
              <?xml version="1.0" encoding="UTF-8"?>
              <success>
                <param1>10</param1>
                <param2>
                  Some text.
                </param2>
              </success>
            )

            @error_response = %q(
              <?xml version="1.0" encoding="UTF-8"?>
              <error>
                <error_code>200</error_code>
                <error_msg>
                  Permission error: the application does not have permission to perform this action
                </error_msg>
              </error>
            )
          end

          it 'should not raise an error' do
            expect { Request.new(@api, nil, nil).send(:handle_response, @success_response)}.to_not raise_error
          end

          it 'should raise error' do
            expect { Request.new(@api, nil, nil).send(:handle_response, @error_response)}.to raise_error(Error)
          end

          it 'should raise PermissionDeniedError' do
            expect { Request.new(@api, nil, nil).send(:handle_response, @error_response)}.to raise_error(PermissionDeniedError)
          end
        end

        context 'for JSON' do

          before(:each) do
            @api = API.new

            @success_response = %q({
              "success": {
                "item1": "Some text",
                "item2": 10
              }
            })

            @error_response = %q({
              "error": {
                "error_msg": "Permission error: the application does not have permission to perform this action",
                "error_code": 200
              }
            })
          end

          it 'should not raise an error' do
            expect { Request.new(@api, nil, nil).send(:handle_response, @success_response)}.to_not raise_error
          end

          it 'should raise error' do
            expect { Request.new(@api, nil, nil).send(:handle_response, @error_response)}.to raise_error(Error)
          end

          it 'should raise PermissionDeniedError' do
            expect { Request.new(@api, nil, nil).send(:handle_response, @error_response)}.to raise_error(PermissionDeniedError)
          end
        end
      end
    end

    describe GetRequest do
      class GetRequest; alias_method :send_via_get, :get; end

      it 'should have get method' do
        GetRequest.new(nil, nil, nil).should respond_to(:get)
      end

      it 'should send a request via HTTP GET' do
        WebMock.disable_net_connect!
        stub_request(:get, /#{MailRU::API::PATH}.*/).to_return(body: [].to_json)
        GetRequest.new(API.new, nil, nil).send_via_get
        WebMock.should have_requested(:get, /#{MailRU::API::PATH}.*/)
        WebMock.allow_net_connect!
      end
    end

    describe PostRequest do
      class PostRequest; alias_method :send_via_post, :post; end

      it 'should have post method' do
        PostRequest.new(nil, nil, nil).should respond_to(:post)
      end

      it 'should send a request via HTTP POST' do
        WebMock.disable_net_connect!
        stub_request(:post, /#{MailRU::API::PATH}.*/).to_return(body: [].to_json)
        PostRequest.new(API.new, nil, nil).send_via_post
        WebMock.should have_requested(:post, /#{MailRU::API::PATH}.*/)
        WebMock.allow_net_connect!
      end
    end
  end
end