class Wow::SearchController < ApplicationController
  def index
    authorize([:wow, :search])
    items = Wow::Item.filter_by_name(params[:query]).limit(10).pluck(:name, :id)

    @item_name = (Wow::Character::ITEM_NAMES & [params[:item_name].to_sym]).first
    @options_for_select = [
      items,
      items.size == 1 ? items.first[1] : nil
    ]

    render layout: false
  end
end