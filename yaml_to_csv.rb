# frozen_string_literal: true

require 'yaml'
require 'csv'

# Convert YAML Files to CSV - Arguement (YAMLFILEPATH, CSVPATHWITHNAME.CSV)
class YamlToCsv
  attr_reader :csv_path_with_name, :headers, :yaml_data

  def initialize(yaml_path, csv_path_with_name, headers = [])
    @yaml_path = yaml_path
    @csv_path_with_name = csv_path_with_name
    @headers = headers
    @yaml_data = YAML.load_file(yaml_path)
  end

  def convert
    CSV.open(csv_path_with_name, 'wb') do |csv|
      csv << headers if headers.any?

      iterate(yaml_data) do |keys, value|
        csv << if value =~ %r{^(.+)?(/\*\s*(.+?)\s*\*/)$}
                 [keys, Regexp.last_match(1).strip, Regexp.last_match(3).strip].flatten
               else
                 [keys, value].flatten
               end
      end
    end
  end

  private

  def iterate(yaml_data, keys = [], &block)
    if [Hash, Array].include?(yaml_data.class)
      send("#{yaml_data.class.to_s.downcase}_iterate", yaml_data, keys, &block)
    else
      yield keys, yaml_data
    end
  end

  def array_iterate(yaml_data, keys, &block)
    yaml_data.each { |_v| iterate(yaml_data, keys, &block) }
  end

  def hash_iterate(yaml_data, keys, &block)
    yaml_data.each do |k, v|
      keys << k
      iterate(v, keys, &block)
      keys.pop
    end
  end
end

YamlToCsv.new('/home/er/projects/ruby/yml_to_csv/dummy-data/example.yml',
              '/home/er/projects/ruby/yml_to_csv/dummy-data/example.csv',
              %w[department technology name experience]).convert
