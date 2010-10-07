# Author::    Jacob O'Donnell  (mailto:jacobodonnell@gmail.com)
# Date::      August 7th, 2010

require 'date'

# This class represents a record.  It does a little data normalization but other then that acts as a container
# for it's properties and provides a friendly to_s method.  Once created it is immutable.
class Record
  attr_reader :first_name, :last_name, :gender, :date_of_birth, :favorite_color
  
  def initialize(record_hash)
    @first_name = record_hash['first_name']
    @last_name = record_hash['last_name']
    @gender = gender_format(record_hash['gender'])
    @date_of_birth = date_format(record_hash['date_of_birth'])
    @favorite_color = record_hash['favorite_color']
  end

  def to_s
    dob = "#{@date_of_birth.month()}/#{@date_of_birth.day()}/#{@date_of_birth.year()}"
    
    "#{@last_name} #{@first_name} #{@gender} #{dob} #{@favorite_color}"
  end

  private
  def date_format(date)
    month, date, year = date.match('(\d+)[-/](\d+)[-/](\d+)').captures
    
    Date.new(year.to_i, month.to_i, date.to_i)
  end

  def gender_format(gender)
    if gender == 'M':
        gender = 'Male'
    elsif gender == 'F':
        gender = 'Female'
    end
    
    gender
  end

end
