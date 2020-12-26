class Calendar::EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_object, only: %i[show edit update destroy]
  before_action do
    Lasha.setup_data(
      **CONFIG[:data].merge!(
        controller: self,
        collection: current_collection,
      )
    )
  end

  CONFIG = {
    data: {
      attributes: {
        name: {
          type: :text_field,
        },
        description: {
          type: :rich_text_area,
        },
        start_time: {
          type: :datetime_select,
        }
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
      name
      description
      start_time
    ]
  }

  def index
    authorize(current_collection)
    @data[:collection] = Calendar::Event.includes(:event_signups).all.order(created_at: :desc)
  end

  def show
    authorize(@object)
    @event_signup = Wow::EventSignup.find_or_initialize_by(
      calendar_event_id: @object.id,
      user: current_user
    )
    @event_signup_data = {
      object: @event_signup,
      attributes: {
        status: {
          type: :select,
          collection: Wow::EventSignup.statuses.to_a,
          include_blank: false
        },
        comment: {
          type: :text_field,
        },
        wow_character_id: {
          type: :select,
          collection: current_user.characters.pluck(:name, :id)
        },
      }
    }
  end

  def new
    authorize(@data[:object])
  end

  def edit
    authorize(@object)
  end

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
    authorize(@object)

    @object.destroy
    redirect_to url_for(action: :index), notice: "#{current_model.model_name.human} was successfully destroyed."
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
