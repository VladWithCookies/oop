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
    load('book')
    load('reader')
    load('author')
    load('order')
  end

  def save_library
    save('book')
    save('reader')
    save('author')
    save('order')
  end

  def save(class_name) 
    filename = "./db/#{class_name}s.txt"
    File.truncate(filename, 0)
    array = instance_variable_get("@#{class_name}s")
    array.each do |obj|
      data = []
      obj.instance_variables.map { |name| data << obj.instance_variable_get(name) }
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

  def get_ordered_books
    ordered_books = []
    @orders.map { |order| ordered_books << order.book_title}
    ordered_books
  end

  def who_often_takes_the_book(book_title)
    readers = []
    @orders.map { |order| readers << order.reader if order.book_title == book_title }  
    return mode(readers)
  end

  def most_popular_books(n)
    ordered_books = get_ordered_books
    most_popular = []
    n.times do
      most_popular << mode(ordered_books)
      ordered_books.delete(mode(ordered_books))
    end
    most_popular  
  end

  def popular_books_orders_count(n)
    most_popular = most_popular_books(n)
    count = 0
    n.times do
      readers = []
      @orders.each do |order|
        if !readers.include?(order.reader) && order.book_title == most_popular.first
          count += 1
          readers << order.reader
        end
      end
      most_popular.shift
    end
    return count
  end

  private 
    def mode(array)
      array.group_by { |e| e }.values.max_by(&:size).first
    end
end