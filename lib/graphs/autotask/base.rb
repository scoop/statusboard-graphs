require 'autotask_api'
require 'graphs/base'

module Graphs
  module Autotask
    class Base < ::Graphs::Base
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
