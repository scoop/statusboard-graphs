# encoding: UTF-8
require 'highrise'

module Graphs
  class HighriseDeals < Base
    title 'Deals 4 Weeks'
    filename 'deals.json'
    totals true
    yaxis units: { prefix: '€' }

    def initialize
      ::Highrise::Base.site = 'https://%s' % config['highrise']['host']
      ::Highrise::Base.user = config['highrise']['user']
      ::Highrise::Base.format = :xml
    end

    def result
      [].tap do |sequences|
        since = 28.days.ago.strftime('%Y%m%d%H%M%S')
        ::Highrise::Deal.find(:all, params: { since: since }).group_by(&:status).each do |status, deals|
          datapoints = [].tap do |datapoints|
            deals.group_by { |d| d.updated_at.to_date }.sort.each do |date, deals|
              next unless date
              datapoints << {
                title: date.strftime('%d %b'),
                value: deals.collect { |d| d.price.to_i }.sum
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
