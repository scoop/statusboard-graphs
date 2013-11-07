require 'autotask_api'
require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/date/calculations'

module Tables
  module Autotask
    class Todo < Base
      filename 'todo-overview.html'

      def query
        AutotaskAPI::QueryXML.new do |query|
          query.entity = 'accounttodo'
        end.tap do |query|
          query.add_condition 'startdatetime', 'lessthan',
            1.day.from_now.midnight.utc.xmlschema.gsub(/Z$/, '')
        end
      end

      def entities
        client.entities_for(query)
      end

      def fetch
        @agents = {}.tap do |agents|
          entities.group_by(&:assigned_to_resource).each do |resource, todos|
            next if resource.blank?
            agents.update resource.first_name => {
              size: todos.size,
              bar: size_bar(todos.size)
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
