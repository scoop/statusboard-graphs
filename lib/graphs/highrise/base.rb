require 'highrise'
require 'graphs/base'

module Graphs
  module Highrise
    class Base < ::Graphs::Base
      def initialize
        ::Highrise::Base.site = 'https://%s' % config['highrise']['host']
        ::Highrise::Base.user = config['highrise']['user']
        ::Highrise::Base.format = :xml
      end
    end
  end
end
