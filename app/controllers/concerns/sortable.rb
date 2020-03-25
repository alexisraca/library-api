module Sortable
  def sortings
    return default_sort unless params[:sort]
    params[:sort] = JSON.parse(params[:sort]) if params[:sort].is_a?(String)
    raise ActionController::NotImplemented.new("There is no sorting feature available") if whitelisted_sortings.blank?
    raise ActionController::NotImplemented.new("There is no sorting within allowed columns") unless sorting_allowed_columns?
    whitelisted_sortings.inject([]) do |sum, (sort_key, sort_value)|
      sort_key = sort_key.to_sym
      sum << add_direction(sort_key, sort_value) if direction_parameter?(sort_key)
      sum
    end
  end

  def add_direction(sort_key, sort_value)
    if sort_value.is_a?(String)
      [sort_value, params[:sort][sort_key]].join(" ")
    else
      { sort_value => params[:sort][sort_key] }
    end
  end

  def whitelisted_sortings
    []
  end

  def default_sort
    []
  end

  def direction_parameter?(sort_key)
    params[:sort][sort_key] && [:asc, :desc].include?(params[:sort][sort_key].to_sym)
  end

  def sorting_allowed_columns?
    (whitelisted_sortings.keys & params[:sort].keys.map(&:to_sym)).present?
  end
end