@students = []

def interactive_menu
  loop do
    print_menu
    print "Type a number from the menu, followed by the return key: "
    get_command
  end
end

def print_menu
  puts "1. Input student details"
  puts "2. Display list of students"
  puts "3. Save list of students to file (students.csv)"
  puts "4. Load the saved list"
  puts "9. Exit the program"
end

def get_command
  case gets.chomp
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
      puts "Selection not recognised..."
  end
end

def input_students
  puts "Please enter the names of the students"
  puts "To finish, hit return twice"
  name = gets.chomp
  while !name.empty? do
    @students << {name: name, cohort: :november}
    puts "Now we have #{@students.count} students"
    name = gets.chomp
  end
end

def show_students
  print_header
  print_students_list
  print_footer
end

def save_students
  file = File.open("students.csv", "w")
  @students.each do |student|
    student_data = [student[:name], student[:cohort]]
    csv_line = student_data.join(",")
    file.puts csv_line
  end
  file.close
end

def load_students
  file = File.open "students.csv", "r"
  file.readlines.each do |line|
    name, cohort = line.chomp.split(",")
    @students << {name: name, cohort: cohort.to_sym}
  end
  file.close
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

interactive_menu