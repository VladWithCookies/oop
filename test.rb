require './library.rb'

my_lib = Library.new

puts "Most popular book is #{my_lib.most_popular_books(1)}"
puts "Color of Magic is #{my_lib.who_often_takes_the_book("Color of Magic")} favorite book"	
puts "#{my_lib.popular_books_orders_count(3)} readers order 1 of 3 most popular books"

my_lib.save_library