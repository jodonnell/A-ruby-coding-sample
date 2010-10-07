# Author::    Jacob O'Donnell  (mailto:jacobodonnell@gmail.com)
# Date::      August 7th, 2010

# This class is used to print the records.  The different methods provide different sorting of the records 
# before printing.
# Usage:
# display_records = DisplayRecords.new(records)
# display_records.print_sorted_by_last_name_desc
class DisplayRecords
  def initialize(records)
    @records = records
  end

  def print_sorted_by_last_name_desc
    @records.sort! { |a,b| b.last_name <=> a.last_name }
    print_records()
  end

  def print_sorted_by_gender_then_last_name
    @records = @records.sort_by { |a| [a.gender, a.last_name] }
    print_records()
  end

  def print_sorted_by_date_of_birth
    @records.sort! { |a,b| a.date_of_birth <=> b.date_of_birth }
    print_records()
  end

  private

  def print_records
    for record in @records
      puts record
    end
  end
end
