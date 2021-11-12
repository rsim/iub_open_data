# encoding: utf-8
require "csv"

results_file = File.open("results.csv", "w", encoding: "UTF-8")

header_printed = false

Dir["results-*.csv"].each do |file_name|
  CSV.foreach(file_name, encoding: "UTF-8") do |row|
    if row[0] == 'pvs_number'
      next if header_printed
      header_printed = true
    end

    results_file.puts row.to_csv
  end
end

results_file.close
