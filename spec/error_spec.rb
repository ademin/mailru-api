#:encoding: utf-8

require 'mailru-api'

module MailRU
  class API
    describe Error do
      context 'create' do
        [{code: 1, klass: UnknownError},
         {code: 2, klass: UnknownMethodCalledError},
         {code: 3, klass: MethodIsDeprecatedError},
         {code: 100, klass: InvalidParameterError},
         {code: 102, klass: AuthorizationFailedError},
         {code: 103, klass: ApplicationLookupFailedError},
         {code: 104, klass: IncorrectSignatureError},
         {code: 105, klass: ApplicationIsNotInstalledError},
         {code: 200, klass: PermissionDeniedError},
         {code: 202, klass: AccessToObjectDeniedError},
         {code: 501, klass: IncorrectImageError}
        ].each do |err|

          it "should return #{err[:klass]} when error code is #{err[:code]}" do
            Error.create(err[:code], '').class.should eq(err[:klass])
          end

          it "should have error code set to #{err[:code]} and description set to #{err[:klass].name}" do
            e = Error.create(err[:code], err[:klass].name)
            e.code.should eq(err[:code])
            e.description.should eq(err[:klass].name)
          end
        end
      end
    end
  end
end