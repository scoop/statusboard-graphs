require 'faraday'

module Graphs
  module Zendesk
    class Overview < Base
      title 'Ticket Overview'
      filename 'tickets-overview.json'
      options totals: false

      def views
        config['zendesk']['views']
      end

      def views_invert
        views.invert
      end

      def url
        "https://%s/api/v2/views/count_many.json?ids=%s" % [config['zendesk']['host'], views.values.join(',')] 
      end

      def connection
        @connection ||= Faraday.new(url).tap do |connection|
          connection.basic_auth config['zendesk']['user'], config['zendesk']['pass']
        end
      end

      def response 
        JSON(connection.get.body)
      end

      def result
        [].tap do |sequences|
          response['view_counts'].each do |element|
            title = views_invert[element['view_id'].to_i]
            sequences << {
              title: title,
              datapoints: [
                { title: title, value: element['value'] }
              ]
            }
          end
        end
      end
    end
  end
end
