require 'yaml'
require 'active_support/core_ext'
require 'statusboard/base'

module Graphs
  class Base < Statusboard::Base
    def no_data
      {
        graph: {
          title: title,
          error: {
            message: 'No data found'
          }
        }
      }.to_json
    end

    def to_s
      return no_data if result.blank?
      {
        graph: {
          title: title,
          datasequences: result,
          total: options[:totals],
          yAxis: options[:yaxis]
        }
      }.to_json
    end
  end
end
