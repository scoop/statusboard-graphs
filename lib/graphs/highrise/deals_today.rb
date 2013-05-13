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
    end
  end
end
