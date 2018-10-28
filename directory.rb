require 'io/console'
require 'csv'
require 'date'

@students = []
@menu = [{command_char: "1", label: "1. Input student details", method: :input_students},
  {command_char: "2", label: "2. Display list of students", method: :show_students},
  {command_char: "3", label: "3. Save list of students to file", method: :save_students},
  {command_char: "4", label: "4. Load details from file", method: :load_students},
  {command_char: "9", label: "9. Exit the program", method: :exit}]
@cohort = Date.today.strftime("%B")

def try_load_students
  load_students(ARGV.first ? ARGV.first : "students.csv")
end

def interactive_menu
  loop do
    print_menu
    get_command
  end
end

def print_menu
  puts
  @menu.each {|entry| puts entry[:label] unless !entry}
end

def get_command
  print "\nType a number from the menu: "
  input = STDIN.getch
  @menu.each do |option|
    if option[:command_char] == input
      puts option[:label]
      self.send option[:method]
      return
    end
  end
  print "#{input}\nSelection not recognised..."
  get_command
end

def input_students
  puts "The cohort is currently set as: #{@cohort}"
  puts "If you wish to enter students for another cohort, type the cohort name and hit return; otherwise, hit return without typing anything"
  unless (text_entered = gets.chomp) == ""
    @cohort = text_entered
  end
  puts "Please enter the names of the students"
  puts "To finish, hit return twice"
  name = STDIN.gets.chomp
  while !name.empty? do
    add_record(name)
    puts "Now we have #{@students.count} students"
    name = STDIN.gets.chomp
  end
end

def show_students
  print_header
  print_students_list
  print_footer
end

def get_filename
  puts "Enter the file name and hit return; the .csv extension will be added automatically"
  puts "If you hit return without entering a name, the default file will be used (students.csv)"
  input = gets.chomp
  return "#{input == "" ? "students" : input}.csv"
end

def save_students
  CSV.open(get_filename, "w") do |file|
    @students.each { |student| file << [student[:name], student[:cohort]] }
  end
  puts "Save complete"
end

def load_students(filename = nil)
  filename = get_filename if !filename
  if File.exists?(filename)
    CSV.foreach(filename) do |line|
      name, cohort = line
      add_record(name, cohort)
    end
    puts "Loaded entries from #{filename}; there are now #{@students.count} students"
  else
    puts "Could not find the file #{filename}"
  end
end

def add_record(name, cohort = @cohort)
  @students << {name: name, cohort: cohort.to_sym}
end

def print_header
  puts "\nThe students of Villains Academy"
  puts "-------------"
end

def print_students_list
  @students.each { |student| puts "#{student[:name]} (#{student[:cohort]} cohort)" }
end

def print_footer
  puts "Overall, we have #{@students.count} great students"
end

try_load_students
interactive_menu