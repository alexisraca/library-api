class ContentBuilder
  attr_reader :page, :content

  def initialize(page_id:)
    @page = Page.find(page_id)
    @content = @page.contents.build
  end

  def call(content_params)
    allowed_format = find_format(content_params[:format])
    if !allowed_format
      content.errors.add(:content_format, "not allowed")
      return
    end

    content.file = content_params[:file]
    content.body = content_params[:body]
    content.content_format = allowed_format
    content.save
  end

  private

  def find_format(format)
    ContentFormat.where("LOWER(name) = LOWER(?)", format).first
  end
end