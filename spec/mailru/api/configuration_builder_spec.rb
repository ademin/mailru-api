require 'spec_helper'

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
end
