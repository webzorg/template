class TreesController < ApplicationController
  # before_action :set_paper_trail_whodunnit
  before_action :set_object, only: %i[show edit update destroy]
  before_action do
    Lasha.setup_data(
      CONFIG[:data].merge!(
        controller: self,
        collection: current_collection,
      )
    )
  end

    CONFIG = {
    data: {
      attributes: {
        title: {
          type: :text_field
        },
        content: {
          type: :rich_text_area
        },
        toggler: {
          type: :check_box,
          skip_index: true
        }
        # start_time: {
        #   type: :datetime_select,
        # }
        # wish_category_id: {
        #   type: :select,
        #   collection: WishCategory.all.map { |u| [u.name, u.id] },
        #   skip_index: true
        # },
        # wish_urgency_id: {
        #   type: :select,
        #   collection: WishUrgency.all.map { |u| [u.name, u.id] },
        #   skip_index: true
        # },
        # user_id: {
        #   type: :select,
        #   label: "owner",
        #   collection: User.all.map { |u| [u.email, u.id] },
        #   override_value: ->(object) { object.public_send(:user).email },
        #   disabled: true,
        #   skip_index: true
        # },
        # selec_example: {
        #   type: :select,
        #   collection: User.all.map { |u| [u.email, u.id] },
        # }
      },
      pagy_items: 10,
      scope_filters: false
    },
    strong_params: %i[
      title
      content
      toggler
      aasm_state
    ]
  }

  def index; end

  def show; end

  def new; end

  def edit; end

  def create
    @object = current_model.public_send(:new, object_params.merge(user_id: current_user.id))
    authorize(@object)

    if @object.save
      redirect_to url_for(action: :show, id: @object), notice: "#{current_model.model_name.human} was successfully created."
    else
      @data[:object] = @object
      render :new
    end
  end

  def update
    authorize(@object)

    if @object.update(object_params)
      redirect_to url_for(action: :show, id: @object), notice: "#{current_model.model_name.human} was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @object.destroy
    redirect_to trees_url, notice: "Tree was successfully destroyed."
  end

  private

    def set_object
      @object = current_model.public_send(:find, params[:id])
    end

    def object_params
      params.require(current_model(return_type: :symbol)).permit(CONFIG[:strong_params])
    end

    def current_collection
      if action_name.to_sym.eql?(:index)
        policy_scope(current_model)
      else
        current_model.none
      end
    end
end
