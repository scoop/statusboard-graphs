$:.unshift File.expand_path("../lib", __FILE__)

require 'graphs/base'
require 'graphs/highrise_deals'
require 'graphs/highrise_sales'
require 'graphs/zendesk_agent'
require 'graphs/zendesk_overview'

class Graph < Thor
  desc 'all', 'Generate all available stats'
  def all
    invoke :highrise
    invoke :zendesk
  end

  method_option :only, type: :array, desc: 'Generate the specified graph data only (Options are: deals, sales)'
  desc 'highrise', 'Generate stats for Highrise Deals'
  def highrise
    Graphs::HighriseDeals.new.to_file if options[:only].blank? || options[:only].include?('deals')
    Graphs::HighriseSales.new.to_file if options[:only].blank? || options[:only].include?('sales')
  end

  desc 'zendesk', 'Generate stats for Zendesk Tickets'
  method_option :only, type: :array, desc: 'Generate the specified graph data only (Options are: overview, agent)'
  def zendesk
    Graphs::ZendeskOverview.new.to_file if options[:only].blank? || options[:only].include?('overview')
    Graphs::ZendeskAgent.new.to_file if options[:only].blank? || options[:only].include?('agent')
  end
end
