class TreesController < ApplicationController
  prepend_before_action :set_tree, only: %i[show edit update destroy]
  prepend_before_action only: :create do
    @object = Tree.new(tree_params)
  end

  STRONG_PARAMS = %i[title content toggler aasm_state].freeze

  before_action do
    collection = if action_name.to_sym.eql?(:index)
                   Tree.all.order(created_at: :desc)
                 else
                   Tree.none
    end

    (@data ||= {}).merge!(
      Lasha.setup_data(
        controller: self,
        collection: collection,
        attributes: {
          title: {
            type: :text_field
          },
          content: {
            type: :text_area
          },
          toggler: {
            type: :check_box,
            skip_index: true
          }
        },
        pagy_items: 10,
        scope_filters: true
      )
    )
  end

  def index; end

  def show; end

  def new; end

  def edit; end

  def create
    if @object.save
      redirect_to @object, notice: "Tree was successfully created."
    else
      render :new
    end
  end

  def update
    if @object.update(tree_params)
      redirect_to @object, notice: "Tree was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @object.destroy
    redirect_to trees_url, notice: "Tree was successfully destroyed."
  end

  private

    def set_tree
      @object = Tree.find(params[:id])
      # @data = { object: @object }
    end

    def tree_params
      params.require(:tree).permit(STRONG_PARAMS)
    end
end
