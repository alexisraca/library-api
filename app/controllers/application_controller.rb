class ApplicationController < ActionController::API
  before_action :authenticate

  rescue_from ActiveRecord::RecordNotFound do |exception|
    head 404
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
    render_error(exception.record, 422)
  end

  rescue_from ActionController::NotImplemented do |exception|
    render json: {
      status: "error",
      message: exception.message,
      pointers: "Method is not implemented correctly"
    }, status: :not_implemented
  end

  private

  # used only for Books lists
  def render_collection(collection, args = {})
    meta = params[:page].present? ? {
        page: params[:page] || 1,
        per: params[:per] || 100,
        pages: args[:total_pages] || collection.total_pages,
        total_records: args[:total_records] || total_model_records(collection)
      } : { total_records: args[:total_records] || total_model_records(collection) }
    render json: collection, meta: meta, **args
  end

  def total_model_records(collection)
    collection.try(:model).try(:count) || collection.first.class.count
  end

  def render_resource(record, **args)
    if !record.errors.empty?
      render_error(record)
    else
      render json: record, **args
    end
  end

  def render_error(record = nil, message = nil, status = 422)
    render json: {
      status: "error",
      message: message || record.try(:errors).try(:full_messages),
      pointers: record.try(:errors).try(:messages),
    }, status: status
  end

  def authenticate
    @authenticated = AuthorizeApiRequest.call(request.headers).result
    render json: { error: 'Not Authorized' }, status: 401 unless @authenticated
  end
end
