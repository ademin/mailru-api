require 'spec_helper'

module MailRU
  class API
    describe Format do
      it %q(should return 'xml' for XML) do
        Format::XML.should eq('xml')
      end

      it %q(should return 'json' for JSON) do
        Format::JSON.should eq('json')
      end
    end
  end
end
