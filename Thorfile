$:.unshift File.expand_path("../lib", __FILE__)

require 'graphs/highrise'
require 'graphs/zendesk'

require 'tables/zendesk'

class Graph < Thor
  desc 'all', 'Generate all available graphs'
  def all
    invoke :highrise
    invoke :zendesk
  end

  method_option :only, type: :array, desc: 'Generate the specified graph data only (Options are: deals deals-today, sales, recordings)'
  desc 'highrise', 'Generate graphs for Highrise Deals'
  def highrise
    Graphs::Highrise::Deals.new.to_file if options[:only].blank? || options[:only].include?('deals')
    Graphs::Highrise::DealsToday.new.to_file if options[:only].blank? || options[:only].include?('deals-today')
    Graphs::Highrise::Sales.new.to_file if options[:only].blank? || options[:only].include?('sales')
    Graphs::Highrise::Recordings.new.to_file if options[:only].blank? || options[:only].include?('recordings')
  end

  desc 'zendesk', 'Generate stats for Zendesk Tickets'
  method_option :only, type: :array, desc: 'Generate the specified graph data only (Options are: overview, agent)'
  def zendesk
    Graphs::Zendesk::Overview.new.to_file if options[:only].blank? || options[:only].include?('overview')
    Graphs::Zendesk::Agent.new.to_file if options[:only].blank? || options[:only].include?('agent')
  end
end

class Table < Thor
  desc 'all', 'Generate all available tables'
  def all
    invoke :zendesk
  end

  desc 'zendesk', 'Generate tables for Zendesk Tickets'
  def zendesk
    ::Tables::Zendesk::Agent.new.to_file
  end
end
