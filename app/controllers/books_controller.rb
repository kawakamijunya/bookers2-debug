class BooksController < ApplicationController
   before_action :authenticate_user!
   before_action :ensure_correct_user, only: [:update,:edit,:destroy]


  def show
    @book_new = Book.new
    @book = Book.find(params[:id])
    @user = @book.user
    @book_comment = BookComment.new
    @view_counts = ViewCount.find_by(ip: request.remote_ip)
     if @view_counts
       @books = Book.all
     else
       @books = Book.all
       ViewCount.create(ip: request.remote_ip)
     end
  end

  def index
    to = Time.current.at_end_of_day #Time.current は現在日時を取得,at_end_of_day は1日の終わりを23:59に設定
    from = (to - 6.day).at_beginning_of_day #at_beginning_of_day は1日の始まりの時刻を0:00に設定
    @books = Book.includes(:favorites).
     sort_by {|x| #sort_byメソッドを使っていいね数を少ない順に取り出している
      x.favorites.where(created_at: from...to).size
     }.reverse #このままだと少ない順に表示されてしまうので最後にreverse
    @book = Book.new
    @user = User.find_by(params[:user_id])
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book.id), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title,:body,:user_id)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    @user = @book.user
    unless @user == current_user
      redirect_to books_path
    end
  end
end
