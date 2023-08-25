# frozen_string_literal: true

require 'yaml'
require 'csv'

# Convert YAML Files to CSV - Arguement (YAMLFILEPATH, CSVPATHWITHNAME.CSV)
class YamlToCsv
  attr_reader :yaml_path, :csv_path_with_name

  def initialize(yaml_path, csv_path_with_name)
    @yaml_path = yaml_path
    @csv_path_with_name = csv_path_with_name
  end

  def convert
    yaml_data = YAML.load_file(yaml_path)
    CSV.open(csv_path_with_name, 'wb') do |csv|
      traverse(yaml_data) do |keys, value|
        csv << if value =~ %r{^(.+)?(/\*\s*(.+?)\s*\*/)$}
                 [keys, Regexp.last_match(1).strip, Regexp.last_match(3).strip].flatten
               else
                 [keys, value].flatten
               end
      end
    end
  end

  private

  def traverse(yaml_data, keys = [], &block)
    if [Hash, Array].include?(yaml_data.class)
      send("#{yaml_data.class.to_s.downcase}_traverse", yaml_data, keys, &block)
    else
      yield keys, yaml_data
    end
  end

  def array_traverse(yaml_data, keys, &block)
    yaml_data.each { |_v| traverse(yaml_data, keys, &block) }
  end

  def hash_traverse(yaml_data, keys, &block)
    yaml_data.each do |k, v|
      keys << k
      traverse(v, keys, &block)
      keys.pop
    end
  end
end

YamlToCsv.new('/home/er/projects/ruby/yml_to_csv/dummy-data/example.yml',
              '/home/er/projects/ruby/yml_to_csv/dummy-data/example.csv').convert
