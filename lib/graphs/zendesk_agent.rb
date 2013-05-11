require 'zendesk_api'

module Graphs
  class ZendeskAgent < Base
    title 'Open Tickets by Agent'
    filename 'tickets-agent.json'
    totals true
    yaxis nil

    def zendesk
      @zendesk ||= ZendeskAPI::Client.new do |c|
        c.url = 'https://%s/api/v2' % config['zendesk']['host']
        c.username = config['zendesk']['user']
        c.password = config['zendesk']['pass']
      end
    end

    def result
      [].tap do |sequences|
        zendesk.views.find(id: config['zendesk']['agent_view']).rows.
          group_by { |r| r.assignee.try(:name) }.each do |agent, tickets|
            next unless agent
            title = agent.split.first
            sequences << {
              title: title,
              datapoints: [
                { title: title, value: tickets.size }
              ]
            }
          end
      end
    end
  end
end
