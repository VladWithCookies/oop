class Order
  attr_accessor :book_title
  attr_accessor :reader
  attr_accessor :date

  def initialize(book_title, reader, date)
    @book_title = book_title
    @reader = reader
    @date = date
  end
end