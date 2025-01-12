require 'date'

puts ".....................Event Scheduler..........................."
puts " "
class EVENT

#intialize  
  def initialize(name, s_DateTime, e_DateTime, participants, venue)
    @name = name
    @s_DateTime = DateTime.parse(s_DateTime)
    @e_DateTime = DateTime.parse(e_DateTime)
    @participants = participants
    @venue = venue
  end

#calculating age   
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
    if today.yday < dob.yday  # Adjust age if birthday hasn't occurred yet
      age =age+1
    else 
      age=age+0  
    end
    age
  end

#add participants
  def add_participant(name, dob)
    age = calculating_age(dob)
    return if age.nil?  # Do not add participant if age is invalid
    @participants << { name: name, dob: dob, age: age }  # Append participant to array
  end

#getter method   
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

class SCHEDULING

#initializing empty hash  
  def initialize
    @events_hash = {}
  end

#create event  
  def create_event
    puts "*************Event Details*********************"
    print "Enter the number of events        : "
    num_e=gets.chomp.to_i 
    #time iterator to get the event deatils 
    num_e.times do |i|
    print "Enter event name                  : "
    name = gets.chomp
    if name.empty?    #empty event message
      puts "Event name cannot be empty."
      return
    end

    if @events_hash.key?(name) #duplicate event message
      puts "Event name is duplicate!"
      return
    end

    print "Enter start date and time of event: "
    s_DateTime = gets.chomp
    begin
      s_DateTime_obj = DateTime.parse(s_DateTime)
    rescue ArgumentError
      puts "Invalid date format. Please use DD/MM/YYYY HH:MM."
      return
    end

    print "Enter end date and time of event  : "
    e_DateTime = gets.chomp
    begin
      e_DateTime_obj = DateTime.parse(e_DateTime)
    rescue ArgumentError
      puts "Invalid date format. Please use DD/MM/YYYY HH:MM."
      return
    end

    if s_DateTime_obj >= e_DateTime_obj
      puts "End date cannot be earlier than start date!"
      return
    end

    participants_array = []
    print "Enter the number of participants  : "
    num_p = gets.chomp.to_i

    num_p.times do |i|
      print "Enter name of participant #{i+1}       : "
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

      participants_array << { name: name_p, dob: dob_p, age: age } #entering participnats details into array in hash format
    end

    print "Enter the venue                        : "
    venue = gets.chomp
    if venue.empty?
      puts "Venue cannot be empty."
      return
    end
    #object of the events_hash hash  with name as key and event as value
    event_obj = EVENT.new(name, s_DateTime, e_DateTime, participants_array, venue)
    @events_hash[name] = event_obj
    puts "*********************************************"
    puts "Event '#{name}' has been created successfully!"
    puts "*********************************************"
    puts " "
  end
  end 
#listing all events
  def list_event
    puts "*************Listing Events*********************"
    @events_hash.each do |name, event|
      print "Event            : #{event.name} \n"
      print "Start Date & Time: #{event.s_DateTime} \n"
      print "End Date & Time  : #{event.e_DateTime} \n"
      print "Participants     : "
      event.participants.each do |i|
        puts "#{i[:name]} (Age: #{i[:age]})"
      end
      print "Venue            : #{event.venue} \n"
      puts ".........................................................."
    end
  end

#maximinum participants in event  
  def max_p
    max_event = @events_hash.values.max_by { |e| e.participants.length }
    puts "Event with maximum participants: #{max_event.name} (Participants: #{max_event.participants.length})"
  end

#minimum participants in event  
  def min_p
    min_event = @events_hash.values.min_by { |e| e.participants.length }
    puts "Event with minimum participants: #{min_event.name} (Participants: #{min_event.participants.length})"
  end

#delete event  
  def delete_event
    print "Do you want to delete past event (y/n) :"
    confo=gets.chomp.downcase
    if confo=='y'
      current_time = DateTime.now
      @events_hash.reject! { |name, event| event.e_DateTime < current_time }
      puts "*********************************"
      puts "Past events removed."
      puts "*********************************"
    else 
      puts "*********************************"
      puts "No events were removed" 
      puts "*********************************" 
    end
  end
end

obj = SCHEDULING.new
obj.create_event
obj.list_event
obj.max_p
obj.min_p
obj.delete_event
