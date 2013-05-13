# encoding: UTF-8
module Graphs
  module Highrise
    class Deals < Base
      title 'Deals 30 Days'
      filename 'deals.json'
      options totals: true, yaxis: { units: { prefix: '€' } }

      def color_for_status(status)
        case status
        when 'lost' then 'red'
        when 'pending' then 'yellow'
        when 'won' then 'green'
        end
      end

      def timespan
        30.days.ago
      end

      def matched_deals
        since = timespan.strftime('%Y%m%d%H%M%S')
        ::Highrise::Deal.find(:all, params: { since: since }).group_by(&:status)
      end

      def result
        [].tap do |sequences|
          matched_deals.each do |status, deals|
            next if status == 'pending'
            previous_date = nil
            datapoints = [].tap do |datapoints|
              deals.group_by { |d| d.status_changed_on }.each do |date, deals|
                next unless date and date >= timespan.to_date
                # fill in the blanks
                if previous_date && previous_date + 1.day < date
                  previous_date += 1.day
                  while previous_date < date
                    datapoints << { title: previous_date.strftime('%d %b'), value: 0 }
                    previous_date += 1.day
                  end
                end

                datapoints << {
                  title: date.strftime('%d %b'),
                  value: deals.collect { |d| d.price.to_i }.sum
                }
                previous_date = date
              end
            end
            sequences << {
              title: status,
              color: color_for_status(status),
              datapoints: datapoints
            }
          end
        end
      end
    end
  end
end
