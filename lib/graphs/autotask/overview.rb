module Graphs
  module Autotask
    class Overview < Base
      title 'Ticket Overview'
      filename 'tickets-overview.json'
      options totals: true

      def query
        AutotaskAPI::QueryXML.new do |query|
          query.entity = 'ticket'
        end.tap do |query|
          query.add_condition 'status', 'notequal',
            config['autotask']['status_closed']
          query.add_condition 'queueid', 'notequal',
            config['autotask']['recurring_queue']
        end
      end

      def entities
        client.entities_for(query)
      end

      def result
        [].tap do |sequences|
          entities.group_by do |e|
            if e.status_name =~ config['autotask']['status_waiting_regex']
              $1
            else
              e.status_name
            end
          end.each do |status, tickets|
            sequences << {
              title: status,
              datapoints: [
                { title: status, value: tickets.size }
              ]
            }
          end
        end
      end
    end
  end
end
