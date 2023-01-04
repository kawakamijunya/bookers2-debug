class FavoritesController < ApplicationController
 before_action :authenticate_user!


  def create
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.new(book_id: @book.id)
    favorite.save
     # 非同期化リダイレクト先を削除
  end


  def destroy
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.find_by(book_id: @book.id)
    favorite.destroy
    # 非同期化リダイレクト先を削除
  end



end
