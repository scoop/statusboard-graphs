require 'highrise'

module Tables
  module Highrise
    class Base < ::Tables::Base
      def initialize
        ::Highrise::Base.site = 'https://%s' % config['highrise']['host']
        ::Highrise::Base.user = config['highrise']['user']
        ::Highrise::Base.format = :xml
      end
    end
  end
end
