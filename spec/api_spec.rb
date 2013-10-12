#:encoding: utf-8

require 'mailru-api'

module MailRU
  class API
    describe ConfigurationBuilder do
      subject { ConfigurationBuilder.new }

     PARAMS.inject({}){ |params, param| params.merge({param => (0...10).map{ (65 + rand(26)).chr }.join}) }.each do |param, value|
        it "should respond to #{param}" do
          subject.should respond_to(param)
        end

        it "should not respond to the #{param} parameter accessor set to #{value}" do
          ConfigurationBuilder.new do
            send(param, value)
          end.should_not respond_to(param).with(0).argument
        end

        it "should return hash with #{param} parameter set to #{value}" do
          configuration = ConfigurationBuilder.new do
            send(param, value)
          end

          configuration.configuration.has_key?(param).should be_true
          configuration.configuration[param].should eq(value)
        end
      end
    end
  end

  describe API do
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
  end
end