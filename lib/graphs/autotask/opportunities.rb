require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/date/calculations'

module Graphs
  module Autotask
    class Opportunities < Base
      title 'Closed Opportunities'
      filename 'closed-opportunities.json'
      options totals: true, yaxis: { units: { prefix: '€' } }

      def query
        AutotaskAPI::QueryXML.new do |query|
          query.entity = 'opportunity'
        end.tap do |query|
          query.add_condition 'closeddate', 'greaterthan',
            30.days.ago.xmlschema
          query.add_condition 'status', 'equals', 3
        end
      end

      def entities
        client.entities_for(query)
      end

      def result
        [].tap do |sequences|
          entities.group_by(&:owner_resource).each do |resource, opportunities|
            sequences << {
              title: resource.first_name,
              datapoints: [
                {
                  title: resource.first_name,
                  value: opportunities.collect { |o| o.amount.to_f }.reduce(:+)
                }
              ]
            }
          end
        end
      end
    end
  end
end
