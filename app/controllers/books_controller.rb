class BooksController < ApplicationController
  include Pagineable
  include Sortable

  def index
    books = Book.ransack(params[:search])
                 .result
                 .page(pagination_params[:page])
                 .per(pagination_params[:per])
    render_collection books.order(*sortings)
  end

  def show
    book = Book.find(params[:id])
    render_resource book
  end

  def update
    book = Book.find(params[:id])
    book.update(name: book_params[:name])
    render_resource book
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy!
    head :ok
  end

  private

  def book_params
    params.require(:book).permit(:name)
  end

  def whitelisted_sortings
    {
      name: :name,
      created_at: :created_at
    }
  end

  def default_sort
    [{ created_at: :desc }]
  end
end
