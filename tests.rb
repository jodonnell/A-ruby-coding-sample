# Author::    Jacob O'Donnell  (mailto:jacobodonnell@gmail.com)
# Date::      August 7th, 2010

require 'test/unit'
require 'stringio'
require 'date'

require 'record.rb'
require 'display_records.rb'
require 'load_records.rb'
require 'main.rb'

TEST_FIRST_NAME = 'Bob'
TEST_LAST_NAME = 'Bimmy'
TEST_GENDER = 'Male'
TEST_DATE_OF_BIRTH = Date.new(1983, 4, 14)
TEST_FAVORITE_COLOR = 'Green'
TEST_DATE_OF_BIRTH_STRING = "#{TEST_DATE_OF_BIRTH.month()}/#{TEST_DATE_OF_BIRTH.day()}/#{TEST_DATE_OF_BIRTH.year()}"
TEST_TO_STRING = "#{TEST_LAST_NAME} #{TEST_FIRST_NAME} #{TEST_GENDER} #{TEST_DATE_OF_BIRTH_STRING} #{TEST_FAVORITE_COLOR}"

RECORD_HASH = record_hash = { 'first_name' => TEST_FIRST_NAME, 'last_name' => TEST_LAST_NAME, 'gender' => TEST_GENDER, 
  'date_of_birth' => TEST_DATE_OF_BIRTH_STRING, 'favorite_color' => TEST_FAVORITE_COLOR }

COMMA_LOAD_TEST = "Bishop, Timothy, Male, Yellow, 4/23/1967"
PIPE_LOAD_TEST = "Bonk | Radek | S | M | Green | 6-3-1975"
SPACE_LOAD_TEST = "Hingis Martina M F 4-2-1979 Green"
SPACE_LOAD_TEST2 = "Seles Monica H F 12-2-1973 Black"

COMMA_TO_S_TEST = "Bishop Timothy Male 4/23/1967 Yellow"
PIPE_TO_S_TEST = "Bonk Radek Male 6/3/1975 Green"
SPACE_TO_S_TEST = "Hingis Martina Female 4/2/1979 Green"
SPACE_TO_S_TEST2 = "Seles Monica Female 12/2/1973 Black"


class TestRecord < Test::Unit::TestCase
  def setup
    @record_hash = RECORD_HASH.dup
  end

  def test_record_print
    record = Record.new(@record_hash)
    assert_equal(TEST_TO_STRING, record.to_s)
  end

  def test_date_convert
    hyphen_date_of_birth = TEST_DATE_OF_BIRTH_STRING.gsub('/', '-')
    @record_hash['date_of_birth'] = hyphen_date_of_birth
    record = Record.new(@record_hash)
    assert_equal(TEST_DATE_OF_BIRTH, record.date_of_birth)
  end

  def test_gender_format
    @record_hash['gender'] = 'M'
    record = Record.new(@record_hash)
    assert_equal(TEST_GENDER, record.gender)
  end
end


class TestLoadRecords < Test::Unit::TestCase
  def setup
    @load_records = LoadRecords.new()
  end

  def test_load_records
    @load_records.load_lines([COMMA_LOAD_TEST], LoadRecords::COMMA)
    @load_records.load_lines([PIPE_LOAD_TEST], LoadRecords::PIPE)
    @load_records.load_lines([SPACE_LOAD_TEST], LoadRecords::SPACE)

    assert(@load_records.records.length > 0, "No records were loaded.")

    found = true
    for record in @load_records.records
      case record.to_s
      when COMMA_TO_S_TEST: ;
      when PIPE_TO_S_TEST: ;
      when SPACE_TO_S_TEST: ;
      else
        found = false
      end
    end
    
    assert(found, "Load records did not load correctly.")
  end

  def test_load_records_bad_type
    assert_raise ArgumentError do
      @load_records.load_lines([], 'non_existant_type')
    end
  end
end


class TestDisplayRecords < Test::Unit::TestCase
  def setup
    load_records = LoadRecords.new()
    load_records.load_lines([COMMA_LOAD_TEST], LoadRecords::COMMA)
    load_records.load_lines([PIPE_LOAD_TEST], LoadRecords::PIPE)
    load_records.load_lines([SPACE_LOAD_TEST], LoadRecords::SPACE)
    load_records.load_lines([SPACE_LOAD_TEST2], LoadRecords::SPACE)
    @display_records = DisplayRecords.new( load_records.records )

    @out = StringIO.new
    $stdout = @out
  end

  def test_sort_by_last_name_desc
    @display_records.print_sorted_by_last_name_desc()
    alphebetical_order_desc = SPACE_TO_S_TEST2 + "\n" + SPACE_TO_S_TEST + "\n" + PIPE_TO_S_TEST + "\n" + COMMA_TO_S_TEST + "\n"
    assert_equal(alphebetical_order_desc, @out.string)
  end

  def test_sort_by_date_of_birth
    @display_records.print_sorted_by_date_of_birth()
    date_of_birth_order = COMMA_TO_S_TEST + "\n" + SPACE_TO_S_TEST2 + "\n" + PIPE_TO_S_TEST + "\n" + SPACE_TO_S_TEST + "\n"
    assert_equal(date_of_birth_order, @out.string)
  end

  def test_sort_by_gender_then_last_name
    @display_records.print_sorted_by_gender_then_last_name()
    gender_then_last_name_order = SPACE_TO_S_TEST + "\n" + SPACE_TO_S_TEST2 + "\n" + COMMA_TO_S_TEST + "\n" + PIPE_TO_S_TEST + "\n"
    assert_equal(gender_then_last_name_order, @out.string)
  end
end

class TestMain < Test::Unit::TestCase
  def setup
    @out = StringIO.new
    $stdout = @out
  end

  def test_main
    main()

    assert_match(/Output 1:\nHingis Martina Female 4\/2\/1979 Green/, @out.string)
    assert_match(/Output 2:\nAbercrombie Neil Male 2\/13\/1943 Tan/, @out.string)
    assert_match(/Output 3:\nSteve Smith Male 3\/3\/1985 Red/, @out.string)
    
    assert_no_match(/Output 1:\nAbercrombie Neil Male 2\/13\/1943 Tan/, @out.string)
  end

end
