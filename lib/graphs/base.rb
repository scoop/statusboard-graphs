require 'yaml'
require 'active_support/core_ext'
require 'statusboard/base'

module Graphs
  class Base < Statusboard::Base
    def to_s
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
