require 'haml'
require 'statusboard/base'

module Tables
  class Base < Statusboard::Base
    def to_s
      fetch
      template = File.read(template_name)
      engine = Haml::Engine.new(template)
      engine.render Object.new, view_assigns
    end

    def view_assigns
      {}.tap do |hash|
        instance_variables.each do |var|
          hash[var] = instance_variable_get(var)
        end
      end
    end

    def template_name
      File.expand_path(File.join(File.dirname(__FILE__), 
                '..', self.class.to_s.underscore + '.html.haml'))
    end
  end
end
