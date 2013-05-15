module Tables
  module Zendesk
    class Agent < Base
      filename 'agent-overview.html'

      def zendesk
        @zendesk ||= ZendeskAPI::Client.new do |c|
          c.url = 'https://%s/api/v2' % config['zendesk']['host']
          c.username = config['zendesk']['user']
          c.password = config['zendesk']['pass']
        end
      end

      def fetch
        @agents = {}.tap do |agents|
          zendesk.views.find(id: config['zendesk']['agent_view']).rows.
            group_by { |r| r.assignee.try(:name) }.each do |agent, tickets|
              next unless agent
              name = agent.split.first
              agents.update name => { 
                size: tickets.size,
                bar: size_bar(tickets.size)
              }
            end
        end
      end

      def size_bar(size)
        case size
        when 0..7 then size
        else 8
        end
      end

    end
  end
end
