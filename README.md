# YAML to CSV Converter

The **YAML to CSV Converter** is a Ruby script that allows you to convert data from YAML files into CSV format. This can be especially useful when you have data stored in YAML format and you need to transform it into CSV for further analysis or sharing.

## How to Use

### Requirements
- Ensure you have Ruby installed on your system. This script also utilizes the `yaml` and `csv` libraries, which are commonly available in Ruby installations.

### Setup
1. Copy the `YamlToCsv` class from the provided code into your Ruby project or script file.

### Usage
1. To use the converter, create an instance of the `YamlToCsv` class and provide the necessary parameters:

   ```ruby
   yaml_path = '/path/to/your/input.yaml'
   csv_path_with_name = '/path/to/your/output.csv'
   headers = %w[department technology name experience] # Optional: Provide column headers for the CSV file

   converter = YamlToCsv.new(yaml_path, csv_path_with_name, headers)
   converter.convert
   ```

   Replace `/path/to/your/input.yaml` with the path to your YAML file and `/path/to/your/output.csv` with the desired path for the generated CSV file. If you want to include column headers in the CSV file, provide them in the `headers` array.

### Run
1. Execute your Ruby script containing the converter code. After running the script, you'll find the converted data in CSV format at the specified output path.

## How It Works

The converter reads data from a YAML file and processes it to create a CSV file. Here's a high-level overview of the process:

1. The `YamlToCsv` class is responsible for handling the conversion. It takes the paths to the input YAML file and the desired output CSV file, along with optional headers.

2. The YAML data is loaded from the input file using the `YAML.load_file` method.

3. The `convert` method initiates the conversion process. It opens the CSV file and starts writing data to it.

4. If headers are provided, they are written as the first row in the CSV file.

5. The `iterate` method is used to traverse through the YAML data recursively. Depending on the data type (Hash or Array), the appropriate method (`hash_iterate` or `array_iterate`) is called.

6. For each key-value pair encountered, the converter determines whether the value needs special processing. If the value matches a specific pattern, it is split into multiple CSV columns.

7. The converted data is written row by row into the CSV file.

8. Once all the data is processed, the CSV file is complete and contains the converted information from the YAML file.

## Example

An example usage of the converter is provided in the given code snippet. It demonstrates how to convert YAML data from `example.yml` into CSV format and save it as `example.csv` with specified headers.
