require 'pry'
require 'csv'

PATH      = 'clippings.txt'
SEPARATOR = '=========='.freeze

file  = File.read(PATH)
notes = file.split(SEPARATOR)

result = notes.map do |note|
  attributes = note.split("\n")
  attributes.delete("\r")

  next if attributes.empty? || attributes.count < 3

  title     = attributes[0].strip.gsub("\xEF\xBB\xBF", '')
  text      = attributes[-1].strip
  timestamp = attributes[1][/(?<=Added on).+/].strip

  [title, text, timestamp]
end.compact

grouped = result.group_by { |note| note[0] }

grouped.each do |book|
  file_name = "#{book[0]}.csv"

  CSV.open(file_name, 'w') do |csv|
    book[1].each do |note|
      csv << note
    end
  end
end
