# frozen_string_literal: true

require 'yaml'
require 'csv'

# YamlToCsv class for converting YAML files to CSV
class YamlToCsv
  attr_reader :csv_path_with_name, :headers, :yaml_data

  # Initialize the converter with YAML file path, CSV file path, and optional headers
  def initialize(yaml_path, csv_path_with_name, headers = [])
    @yaml_path = yaml_path
    @csv_path_with_name = csv_path_with_name
    @headers = headers
    @yaml_data = YAML.load_file(yaml_path)
  end

  # Convert YAML data to CSV format
  def convert
    CSV.open(csv_path_with_name, 'wb') do |csv|
      csv << headers if headers.any?

      # Recursively iterate through YAML data and write to CSV
      iterate(yaml_data) do |keys, value|
        csv << if value =~ %r{^(.+)?(/\*\s*(.+?)\s*\*/)$} # Check for special format
                 [keys, Regexp.last_match(1).strip, Regexp.last_match(3).strip].flatten
               else
                 [keys, value].flatten
               end
      end
    end
  end

  private

  # Recursively iterate through YAML data
  def iterate(yaml_data, keys = [], &block)
    if [Hash, Array].include?(yaml_data.class)
      send("#{yaml_data.class.to_s.downcase}_iterate", yaml_data, keys, &block)
    else
      yield keys, yaml_data
    end
  end

  # Iterate through an array in the YAML data
  def array_iterate(yaml_data, keys, &block)
    yaml_data.each { |_v| iterate(yaml_data, keys, &block) }
  end

  # Iterate through a hash in the YAML data
  def hash_iterate(yaml_data, keys, &block)
    yaml_data.each do |k, v|
      keys << k
      iterate(v, keys, &block)
      keys.pop
    end
  end
end

# Example usage of YamlToCsv class to convert YAML to CSV
YamlToCsv.new('/home/er/projects/ruby/yml_to_csv/dummy-data/example.yml',
              '/home/er/projects/ruby/yml_to_csv/dummy-data/example.csv',
              %w[department technology name experience]).convert
