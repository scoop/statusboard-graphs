require 'highrise'

module Graphs
  class Highrise < Base
    title 'Deals'
    filename 'deals.json'

    def initialize
      ::Highrise::Base.site = 'https://%s' % config['highrise']['host']
      ::Highrise::Base.user = config['highrise']['user']
      ::Highrise::Base.format = :xml
    end

    def result
      [].tap do |sequences|
        since = 30.days.ago.strftime('%Y%m%d%H%M%S')
        ::Highrise::Deal.find(:all, params: { since: since}).group_by(&:status).each do |status, deals|
          datapoints = [].tap do |datapoints|
            deals.group_by { |d| d.updated_at.to_date }.each do |date, deals|
              next unless date
              datapoints << {
                title: date.strftime('%d %b'),
                value: deals.count
              }
            end
          end
          sequences << {
            title: status,
            datapoints: datapoints
          }
        end
      end
    end
  end
end
