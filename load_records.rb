# Author::    Jacob O'Donnell  (mailto:jacobodonnell@gmail.com)
# Date::      August 7th, 2010

require "record.rb"

# This class takes lines that contain records as well as a type and will generate the Record objects from them.
# It handles three type of files.  The lines field order and the delimiter are tied together.
# Sample usage:
# load_records = LoadRecords.new()
# load_records.load_lines(["Bishop, Timothy, Male, Yellow, 4/23/1967"], LoadRecords::COMMA)
# load_records.records
class LoadRecords
  PIPE = 1
  SPACE = 2
  COMMA = 3

  FIELD_FORMAT_COMMA = { 'first_name' => 1, 'last_name' => 0, 'gender' => 2, 'favorite_color' => 3, 'date_of_birth' => 4 }
  FIELD_FORMAT_PIPE  = { 'first_name' => 1, 'last_name' => 0, 'gender' => 3, 'favorite_color' => 4, 'date_of_birth' => 5 }
  FIELD_FORMAT_SPACE = { 'first_name' => 1, 'last_name' => 0, 'gender' => 3, 'favorite_color' => 5, 'date_of_birth' => 4 }

  PIPE_DELIMITER = ' | '
  SPACE_DELIMITER = ' '
  COMMA_DELIMITER = ', '

  attr_reader :records

  def initialize()
    @records = []
  end

  def load_lines(lines, type)
    delimiter = get_delimiter(type)
    format = get_format(type)

    for line in lines
      fields = line.split(delimiter)
      @records.push(Record.new({ 'first_name' => fields[ format['first_name'] ],
                                 'last_name' => fields[ format['last_name'] ],
                                 'gender' => fields[ format['gender'] ],
                                 'favorite_color' => fields[ format['favorite_color'] ],
                                 'date_of_birth' => fields[ format['date_of_birth'] ]
                              }))
    end
  end

  private

  def get_delimiter_format(type)
    case type
    when PIPE: return PIPE_DELIMITER, FIELD_FORMAT_PIPE
    when SPACE: return SPACE_DELIMITER, FIELD_FORMAT_SPACE
    when COMMA: return COMMA_DELIMITER, FIELD_FORMAT_COMMA
    else
      raise ArgumentError.new('Argument type received unknown enumerated value.')
    end
  end

  def get_delimiter(type)
    delimiter, format = get_delimiter_format(type)

    delimiter
  end

  def get_format(type)
    delimiter, format = get_delimiter_format(type)

    format
  end
end
