require 'date'

class EVENT

#initializing parameters  
  def initialize(name, s_DateTime, e_DateTime, participants, venue)
    @name = name
    @s_DateTime = DateTime.parse(s_DateTime)
    @e_DateTime = DateTime.parse(e_DateTime)
    @participants = participants
    @venue = venue
  end

# Calculating age
    def calculating_age(dob)
      begin
      dob = Date.strptime(dob, "%d/%m/%Y")  # Convert DOB to Date object
      rescue ArgumentError
       puts "Invalid date format for DOB. Please use DD/MM/YYYY."
      return nil
      end
      if dob > Date.today
      puts "The date of birth cannot be in the future."
      return nil
      end
      today = Date.today
      age = today.year - dob.year
      if today.yday < dob.yday  # Adjust if birthday hasn't occurred yet
      age=age+1
      else 
        age=age+0
      end
    age
    end

# Add participants
  def add_participant(name, dob)
    age = calculating_age(dob)
    return if age.nil?  # Do not add participant if age is invalid
    @participants << { name: name, dob: dob, age: age }  # Append participant to array
  end

# Getters for event details
  def name
    @name
  end

  def s_DateTime
    @s_DateTime
  end

  def e_DateTime
    @e_DateTime
  end

  def participants
    @participants
  end

  def venue
    @venue
  end
end

@events_hash = {}  #empty hash

puts ".......................Event Scheduler................................"
puts "1 => Create event"
puts "2 => List event"
puts "3 => Max (Event with max participants)"
puts "4 => Min (Event with min participants)"
puts "5 => Delete past events"
puts "6 => Exit"
puts "......................................................................."
loop do 
print "Your selection is : "
sel = gets.chomp.to_i
puts " "
case sel  

when 1
  puts "Event creation"

  print "Enter the number of events        :"
  num_e=gets.chomp.to_i

  num_e.times do |i|
  print "Enter #{i+1} event name                : "
  name = gets.chomp
  # Validate event name
  if name.empty?
    puts "Event name cannot be empty."
    next   #return will stop the iteration that why we have written next to move to nect iteration
  end
  if @events_hash.key?(name)
    puts "Event name is duplicate!"
    next
  end

  print "Enter start date and time of event: "
  s_DateTime = gets.chomp
  begin
    s_DateTime_obj = DateTime.parse(s_DateTime) # Parse start date-time
  rescue ArgumentError
    puts "Invalid date format for start date. Please use DD/MM/YYYY HH:MM."
    next
  end

  print "Enter end date and time of event  : "
  e_DateTime = gets.chomp
  begin
    e_DateTime_obj = DateTime.parse(e_DateTime) # Parse end date-time
  rescue ArgumentError
    puts "Invalid date format for end date. Please use DD/MM/YYYY HH:MM."
    next
  end

  if s_DateTime_obj >= e_DateTime_obj
    puts "End date cannot be earlier than start date!"
    next
  end

  participants_array = [] # Array for participants
  print "Enter the number of participants  : "
  num_p = gets.chomp.to_i

  num_p.times do |i|
    print "Enter name of participant #{i + 1}       : "
    name_p = gets.chomp

    if participants_array.any? { |p| p[:name] == name_p }
      puts "Duplicate names are not allowed."
      next
    end

    print "Enter DOB of participant #{i + 1} (DD/MM/YYYY): "
    dob_p = gets.chomp
    age = EVENT.new(name, s_DateTime, e_DateTime, [], "").calculating_age(dob_p)

    if age.nil?
      next
    end

    participants_array << { name: name_p, dob: dob_p, age: age }
  end

  print "Enter the venue                        : "
  venue = gets.chomp
  if venue.empty?
    puts "Venue cannot be empty."
    next
  end

  # Creating new event object and storing it into an event hash
  event_obj = EVENT.new(name, s_DateTime, e_DateTime, participants_array, venue)
  @events_hash[name] = event_obj
  puts "*************************************************"
  puts "Event '#{name}' has been created successfully!!!!"
  puts "*************************************************"
end 

when 2
  print "Listing events \n"
  if @events_hash.empty?
    puts "No events available. !!!!!!!!"
  else
    @events_hash.each do |name, event|
      puts "Event            : #{event.name}"
      puts "Start Date & Time: #{event.s_DateTime}"
      puts "End Date & Time  : #{event.e_DateTime}"
      print "Participants     : "
      event.participants.each do |i|
        puts "#{i[:name]} (Age: #{i[:age]})"
      end
      puts "Venue            : #{event.venue}"
      puts ".........................................................."
    end
  end

when 3
  if @events_hash.empty?
    puts "No events available. !!!!!!!!"
  else
  puts "Max participated event"
  max_event = @events_hash.values.max_by { |e| e.participants.length }
  puts "Event with maximum participants: #{max_event.name} (Participants: #{max_event.participants.length})"
  puts "......................................................................."
  end

when 4
  if @events_hash.empty?
    puts "No events available. !!!!!!!!"
  else
  puts "Min participated event"
  min_event = @events_hash.values.min_by { |e| e.participants.length }
  puts "Event with minimum participants: #{min_event.name} (Participants: #{min_event.participants.length})"
  puts "......................................................................."
  end 

when 5
  print "Do you want to delete past event (y/n) :"
  confo=gets.chomp.downcase
  if confo=='y'
    current_time = DateTime.now
    @events_hash.delete_if { |name, event| event.e_DateTime < current_time }
    puts "************************"
    puts "Past events removed."
    puts "************************"
  else 
    puts "No events were removed"  
  end 

when 6 
  break  
else
  puts "Invalid option selected."
end

end