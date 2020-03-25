module Pagineable
  extend ActiveSupport::Concern

  included do
    before_action :default_pagination
  end

  def default_pagination
    return if pagination_params[:page].present? && params[:per].present?
    params[:page] = 1
    params[:per] = 5
  end

  def pagination_params
    params.permit(:page, :per)
  end
end