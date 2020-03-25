class PagesController < ApplicationController
  def create
    page = Page.create(book_id: params[:book_id])
    render_resource page
  end

  def show
    page = Page.find_by!(page_number: params[:id])
    render_resource page
  end
end
