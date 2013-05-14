# encoding: UTF-8
module Graphs
  module Highrise
    class DealsToday < Deals
      self.title = 'Deals Today'
      self.filename = 'deals-today.json'
      self.options = { totals: true, yaxis: { units: { prefix: '€' } } }

      def timespan
        Time.now.midnight
      end

      def matched_deals
        since = timespan.strftime('%Y%m%d%H%M%S')
        ::Highrise::Deal.find(:all, params: { since: since, status: 'won' }).group_by(&:status)
      end
    end
  end
end
