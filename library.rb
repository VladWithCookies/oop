require './author.rb'
require './reader.rb'
require './book.rb'
require './order.rb'

class Library 
  attr_accessor :books
  attr_accessor :orders
  attr_accessor :readers
  attr_accessor :authors

  def initialize
    @orders = []
    @books = []
    @readers = []
    @authors = []
    load_library
  end

  def load_library  
    %w(book reader author order).each { |e| load(e)}
  end

  def save_library
    %w(book reader author order).each { |e| save(e)}
  end

  def save(class_name) 
    filename = "./db/#{class_name}s.txt"
    File.truncate(filename, 0)
    array = instance_variable_get("@#{class_name}s")
    array.each do |obj|
      data = obj.instance_variables.map { |name| obj.instance_variable_get(name) }
      File.open(filename, 'a+') do |file|
        file.puts data.join(' - ')
      end
    end
  end

  def load(class_name)
    File.open("./db/#{class_name}s.txt", 'r').each do |line|
      data = line.split(' - ')
      instance_variable_get("@#{class_name}s") << Object.const_get(class_name.capitalize).new(*data)
    end  
  end

  def who_often_takes_the_book(book_title)
    @orders.select { |o| o.book_title == book_title }.group_by { |o| o.reader }.values.max_by(&:count).first.reader
  end

  def most_popular_book
    @orders.group_by { |o| o.book_title}.values.max_by(&:count).first.book_title
  end

  def popular_books_orders_count(n)
    @orders.group_by { |o| o.book_title }.sort_by { |k, v| v.length }.last(n).to_h.values.flatten.uniq { |o| o.reader }.count
  end
end