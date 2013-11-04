require 'autotask_api'
require 'active_support/core_ext/date/calculations'

module Tables
  module Autotask
    class Notes < Base
      filename 'notes-overview.html'

      def query
        AutotaskAPI::QueryXML.new do |query|
          query.entity = 'accountnote'
        end.tap do |query|
          query.add_condition 'startdatetime', 'greaterthan',
            Time.now.midnight
        end
      end

      def entities
        client.entities_for(query)
      end

      def fetch
        @agents = {}.tap do |agents|
          entities.group_by(&:assigned_resource).each do |resource, notes|
            next if resource.blank?
            agents.update resource.first_name => {
              size: notes.size,
              bar: size_bar(notes.size)
            }
          end
        end.sort_by { |name, values| values[:size] }.reverse
      end

      def size_bar(size)
        case size
        when 0..28 then (size/4).round
        else 8
        end
      end

    end
  end
end
