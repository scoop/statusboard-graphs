require 'autotask_api'

module Tables
  module Autotask
    class Agent < Base
      filename 'agent-overview.html'

      def query
        AutotaskAPI::QueryXML.new do |query|
          query.entity = 'timeentry'
        end.tap do |query|
          query.add_condition 'startdatetime', 'greaterthan',
            Time.now.utc.midnight.xmlschema.gsub(/Z$/, '')
        end
      end

      def entities
        client.entities_for(query)
      end

      def fetch
        @agents = {}.tap do |agents|
          entities.group_by(&:resource).each do |resource, time_entries|
            next if resource.blank?
            time_sum = time_entries.collect { |t| t.hours_worked.to_f }.
              reduce(:+).round(1)
            agents.update resource.first_name => {
              size: time_sum,
              bar: size_bar(time_sum)
            }
          end
        end.sort_by { |name, values| values[:size] }.reverse
      end

      def size_bar(size)
        case size.ceil
        when 0..7 then size.ceil
        else 8
        end
      end

    end
  end
end
