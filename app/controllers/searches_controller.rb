class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]
    @word = params[:word]
    @method = params[:method]
    if @range == "user"
      @records = User.search_for(@word, @method)
    elsif @range == 'book'
      @records = Book.search_for(@word, @method)
    elsif @range == 'tag'
			@records = Tag.search_books_for(@word, @method)
    end
  end
end
