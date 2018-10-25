@students = []

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
  puts "\n1. Input student details"
  puts "2. Display list of students"
  puts "3. Save list of students to file"
  puts "4. Load details from file"
  puts "9. Exit the program"
end

def get_command
  print "\nType a number from the menu, followed by the return key: "
  case STDIN.gets.chomp
    when "1"
      input_students
    when "2"
      show_students
    when "3"
      save_students
    when "4"
      load_students
    when "9"
      exit
    else
      print "Selection not recognised..."
      get_command
  end
end

def input_students
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
  file = File.open(get_filename, "w")
  @students.each do |student|
    student_data = [student[:name], student[:cohort]]
    csv_line = student_data.join(",")
    file.puts csv_line
  end
  file.close
  puts "Save complete"
end

def load_students(filename = nil)
  filename = get_filename if !filename
  if File.exists?(filename)
    file = File.open filename, "r"
    file.readlines.each do |line|
      name, cohort = line.chomp.split(",")
      add_record(name, cohort)
    end
    file.close
    puts "Loaded entries from #{filename}; there are now #{@students.count} students"
  else
    puts "Could not find the file #{filename}"
  end
end

def add_record(name, cohort = "november")
  @students << {name: name, cohort: cohort.to_sym}
end

def print_header
  puts "The students of Villains Academy"
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