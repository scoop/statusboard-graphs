module Graphs
  module Highrise
    class Recordings < Base
      title 'Recordings 30 Days'
      filename 'recordings.json'
      options totals: false

      def color_for_status(status)
        case status
        when 'lost' then 'red'
        when 'pending' then 'yellow'
        when 'won' then 'green'
        end
      end

      def result
        [].tap do |sequences|
          ::Highrise::Recording.find_all_across_pages_since(30.days.ago).group_by(&:type).each do |type, recordings|
            datapoints = [].tap do |datapoints|
              recordings.group_by { |d| d.updated_at.to_date }.each do |date, recordings|
                datapoints << {
                  title: date.strftime('%d %b'),
                  value: recordings.count
                }
              end
            end
            sequences << {
              title: type.gsub(/Recording$/, ''),
              datapoints: datapoints
            }
          end
        end
      end
    end
  end
end
