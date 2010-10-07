# Author::    Jacob O'Donnell  (mailto:jacobodonnell@gmail.com)
# Date::      August 7th, 2010
# License::   Distributes under the same terms as Ruby

require "display_records.rb"
require "load_records.rb"

PIPE_FILENAME = 'pipe.txt'
SPACE_FILENAME = 'space.txt'
COMMA_FILENAME = 'comma.txt'

def get_lines_from_file(file_name)
  lines = []
  IO.foreach(file_name) {|line| lines.push(line.chomp)}

  lines
end

def main
  load_records = LoadRecords.new()

  load_records.load_lines( get_lines_from_file(PIPE_FILENAME), LoadRecords::PIPE)
  load_records.load_lines( get_lines_from_file(SPACE_FILENAME), LoadRecords::SPACE)
  load_records.load_lines( get_lines_from_file(COMMA_FILENAME), LoadRecords::COMMA)

  display_records = DisplayRecords.new(load_records.records)

  puts "Output 1:"
  display_records.print_sorted_by_gender_then_last_name()

  puts "\nOutput 2:"
  display_records.print_sorted_by_date_of_birth()

  puts "\nOutput 3:"
  display_records.print_sorted_by_last_name_desc()
end

