#By Stephen Ford, all rights reserved 2015. Developed for Ruby 2.0

#This hash will hold values that have already been discovered. The key is the number to be checked, and the value is how many iterations it takes to be happy
@happy_results_holder = {}

def start_program
	begin
	clear_fields
	puts 'Enter a number to check its happiness.'
	the_starting_number = gets.chomp

	if check_hash_for_happiness(the_starting_number)
		#record already exists in hash, display record description, re-run program for next number
		puts "Number is happy after #{@happy_results_holder[the_starting_number.to_i]} iterations."
		puts ''
	else
		#record does not exist in @happy_results_holder hash - need to check for happiness
		puts "Enter how many iterations you would like to utilize to find the number's happines."
		the_number_of_iterations = gets.chomp
			#We have the values we need to start the check.
			infinity_check(the_starting_number.to_i, the_number_of_iterations.to_i)
	end
	rescue => e
		#If a mega error occurs we display the stacktrace and allow the user to try again
		puts "Something went wrong: #{e.inspect}, at: #{e.backtrace}, the program will restart."
	end
	start_program	
end

def clear_fields
	#If there was an error, clear that out.
	@errors = nil
end	

def check_hash_for_happiness(number)
	#Check if number submitted has already been found before.
	if @happy_results_holder[number.to_i].nil?
		false
	else
		true
	end
end

def infinity_check(num_to_check, num_of_attempts)
	#First we check to ensure values submitted are real numbers
	if check_user_values(num_to_check, num_of_attempts)
		check_sum = num_to_check
		
		num_of_attempts.times do |i|
			check_sum = square_and_sum(check_sum.to_s.chars.map(&:to_i))
			if check_sum == 1
				#Deposit a happy result into our success hash.
				@happy_results_holder[num_to_check] = i + 1
				puts "Number is happy after #{@happy_results_holder[num_to_check]} iterations."
				puts ''
				break
			end
		end
		puts 'Number is not happy =[' if check_sum != 1
	else
		puts "There was an error: #{@errors.join(' ')}."
	end
end

def check_user_values(num_to_check, num_of_attempts)
	#check values entered by user to ensure they're appropriate numbers
	if num_to_check.is_a?(Numeric) && num_to_check > 0
	#Valid number, good to go
	else
		@errors ||= []
		@errors << 'The number to check must be a real number.'
	end

	if num_of_attempts.is_a?(Numeric) && num_of_attempts > 0 && num_of_attempts < 100001
	#Valid number, good to go
	else
		@errors ||= []
		@errors << 'The number of iterations must be a real number between 1 and 100,000.'
	end
	true unless @errors
end

def square_and_sum(values)
	#We iterate through each number in the array submitted, sqaure it and then add it to a sum we return to the infinity check method once all the values have been added together
	results = 0
	values.each { |value| results += value ** 2 }
	results
end

start_program