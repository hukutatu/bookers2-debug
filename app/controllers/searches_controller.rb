class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range =params[:range]
    # @range = Book
    @word =params[:word]
    # @word = rails
    @search = params[:search]
    # @search perfect_match
    
    if @range == "User"
      @users = User.looks(params[:search], params[:word])
    else
      @books = Book.looks(params[:search], params[:word])
    end
  end
end
