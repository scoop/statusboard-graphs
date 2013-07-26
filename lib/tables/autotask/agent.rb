require 'autotask_api'

module Tables
  module Autotask
    class Agent < Base
      filename 'agent-overview.html'

      def query
        AutotaskAPI::QueryXML.new do |query|
          query.entity = 'ticket'
        end.tap do |query|
          query.add_condition 'LastActivityDate', 'greaterthan',
            Date.today.xmlschema
          query.add_condition 'QueueID', 'notequal',
            config['autotask']['recurring_queue']
        end
      end

      def entities
        client.entities_for(query)
      end

      def fetch
        @agents = {}.tap do |agents|
          entities.group_by(&:assigned_resource).each do |resource, tickets|
            next if resource.blank?
            agents.update resource.first_name => { 
              size: tickets.size,
              bar: size_bar(tickets.size)
            }
          end
        end.sort_by { |name, values| values[:size] }.reverse
      end

      def size_bar(size)
        case size
        when 0..15 then (size/1.5).round
        else 8
        end
      end

    end
  end
end
