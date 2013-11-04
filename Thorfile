$:.unshift File.expand_path("../lib", __FILE__)

require 'bundler/setup'

require 'graphs/highrise'
require 'graphs/zendesk'
require 'graphs/autotask'

require 'tables/autotask'
require 'tables/zendesk'
require 'tables/highrise'


class Graph < Thor
  no_commands do
    def config
      Statusboard::Base.config
    end
  end

  desc 'all', 'Generate all available graphs'
  def all
    invoke :highrise if config['highrise']
    invoke :zendesk if config['zendesk']
    invoke :autotask if config['autotask']
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

  desc 'autotask', 'Generate stats for Autotask Tickets'
  method_option :only, type: :array, desc: 'Generate the specified graph data only (Options are: overview)'
  def autotask
    Graphs::Autotask::Opportunities.new.to_file if options[:only].blank? || options[:only].include?('opportunities')
    Graphs::Autotask::Overview.new.to_file if options[:only].blank? || options[:only].include?('overview')
  end
end

class Table < Thor
  no_commands do
    def config
      Statusboard::Base.config
    end
  end

  desc 'all', 'Generate all available tables'
  def all
    invoke :zendesk if config['zendesk']
    invoke :autotask if config['autotask']
    invoke :highrise if config['highrise']
  end

  desc 'zendesk', 'Generate tables for Zendesk Tickets'
  def zendesk
    ::Tables::Zendesk::Agent.new.to_file
  end

  desc 'autotask', 'Generate tables for Autotask Tickets'
  def autotask
    ::Tables::Autotask::Notes.new.to_file
    ::Tables::Autotask::Todo.new.to_file
    ::Tables::Autotask::Agent.new.to_file
  end

  desc 'highrise', 'Generate tables for Highrise Recordings and Tasks'
  def highrise
    ::Tables::Highrise::Recordings.new.to_file
    ::Tables::Highrise::Tasks.new.to_file
  end
end

# vim: ft=ruby
