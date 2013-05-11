# encoding: UTF-8
module Graphs
  module Highrise
    class Sales < Base
      title 'Sales 30 Days'
      filename 'sales.json'
      options totals: true, yaxis: { units: { prefix: '€' } }

      def result
        [].tap do |sequences|
          since = 30.days.ago.strftime('%Y%m%d%H%M%S')
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
end
