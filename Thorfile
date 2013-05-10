$:.unshift File.expand_path("../lib", __FILE__)

require 'faraday'
require 'yaml'
require 'highrise'

require 'graphs/base'
require 'graphs/highrise'
require 'graphs/zendesk'

class Graph < Thor
  desc 'highrise', 'Generate stats for Highrise Deals'
  def highrise
    highrise = Graphs::Highrise.new
    highrise.to_file
  end

  desc 'zendesk', 'Generate stats for Zendesk Tickets'
  def zendesk
    zendesk = Graphs::Zendesk.new
    zendesk.to_file
  end
end
