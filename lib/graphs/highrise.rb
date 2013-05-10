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
        ::Highrise::Deal.find(:all).group_by(&:status).each do |status, deals|
          sequences << {
            title: status,
            datapoints: [
              { title: status.capitalize, value: deals.collect { |d| d.price.to_i }.sum }
            ]
          }
        end
      end
    end
  end
end
