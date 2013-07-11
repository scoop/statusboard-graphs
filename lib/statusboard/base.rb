module Statusboard
  class Base
    class_attribute :title, :filename, :options

    def self.config
      @config ||= YAML.load_file('config.yaml')
    end

    def config
      self.class.config
    end

    [:title, :filename, :options].each do |m|
      class_eval <<-EOM
        def self.#{m}(new_#{m} = nil)
          self.#{m} = new_#{m}
        end
      EOM
    end

    def destination_path
      path = config['destination_path'] || File.expand_path(File.dirname(__FILE__), '../../public')
      File.join(path, filename)
    end

    def to_file
      puts '[%s] Generating %s' % [self.class.name, File.basename(destination_path)]
      output = to_s
      File.open(destination_path, 'w') { |f| f.puts output }
    end
  end
end
