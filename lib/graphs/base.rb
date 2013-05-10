module Graphs
  class Base
    class_attribute :title, :filename

    def config
      @config ||= YAML.load_file('config.yaml')
    end

    [:title, :filename].each do |m|
      class_eval <<-EOM
        def self.#{m} #{m}
          self.#{m} = #{m}
        end
      EOM
    end

    def json_path
      File.expand_path(File.join(File.dirname(__FILE__), '../../public', filename))
    end

    def to_json
      {
        graph: {
          title: title,
          datasequences: result
        }
      }.to_json
    end

    def to_file
      File.open(json_path, 'w') { |f| f.puts to_json }
    end
  end
end
