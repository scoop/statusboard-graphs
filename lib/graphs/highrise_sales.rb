# encoding: UTF-8
require 'highrise'

module Graphs
  class HighriseSales < Base
    title 'Sales 4 Weeks'
    filename 'sales.json'
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
        ::Highrise::Deal.find(:all, params: { since: since, status: 'won' }).group_by(&:responsible_party_id).each do |user_id, deals|
          user = ::Highrise::User.find user_id
          title = user.name.split.first
          sequences << {
            title: title,
            datapoints: [
              {
                title: title,
                value: deals.collect { |d| d.price.to_i }.sum
              }
            ]
          }
        end
      end
    end
  end
end
