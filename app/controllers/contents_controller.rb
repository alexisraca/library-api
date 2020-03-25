class ContentsController < ApplicationController
  def create
    builder = ContentBuilder.new(page_id: params[:page_id])
    builder.call(content_params)
    render_resource builder.content, status: :created
  end

  def show
    page = Page.find(params[:page_id])
    content = page.contents
                  .joins(:content_format)
                  .where("LOWER(content_formats.name) = ?", params[:format])
                  .last

    if content.blank?
      render_not_found
    elsif content.content_format.file?
      # TODO: render binaries
    else
      render plain: content.body, status: :ok
    end
  end

  private

  def render_not_found
    render json: {
      status: "error",
      message: "No content in the required format was found",
    }, status: 404
  end

  def content_params
    params.require(:content).permit(:body, :file, :format)
  end
end
