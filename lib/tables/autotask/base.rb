require 'tables/base'

module Tables
  module Autotask
    class Base < ::Tables::Base
      class_attribute :client

      def initialize
        self.client = AutotaskAPI::Client.new do |c|
          c.basic_auth = [ 
            config['autotask']['user'],
            config['autotask']['password']
          ]
          c.wsdl = config['autotask']['wsdl']
        end
      end
    end
  end
end
