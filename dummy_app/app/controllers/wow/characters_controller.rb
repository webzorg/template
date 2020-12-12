class Wow::CharactersController < ApplicationController
  before_action :authenticate_user!
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
        name: {
          type: :text_field
        },
        wow_race_id: {
          type: :select,
          collection: Wow::Race.all.pluck(:name, :id),
          skip_index: true
        },
        wow_class_id: {
          type: :select,
          collection: Wow::Class.all.pluck(:name, :id),
          skip_index: true
        },
        wow_role_id: {
          type: :select,
          collection: Wow::Role.all.pluck(:name, :id),
          skip_index: true
        },
        # priority: {
        #   type: :select,
        #   collection: Wow::Character.priorities.to_a,
        #   skip_index: false,
        #   include_blank: false
        # },
        priority: {
          type: :radio,
          collection: Wow::Character.priorities.to_a,
          inline: true,
          skip_index: false
        },
        level: {
          type: :select,
          collection: 1..60,
          skip_index: false
        },
        # head: {
        #   type: :select,
        #   collection: Wow::Item.all.pluck(:name, :id),
        #   skip_index: true
        # }
      },
      pagy_items: 10,
      scope_filters: false
    },
    strong_params: %i[
      name
      wow_race_id
      wow_class_id
      wow_role_id
      priority
      level
      head
      neck
      shoulder
      back
      chest
      wrist
      hands
      waist
      legs
      feet
      finger_1
      finger_2
      trinket_1
      trinket_2
      main_hand
      off_hand
      ranged_relic
    ]
  }

  def index
    authorize(CONFIG[:data][:collection])
  end

  def show
    authorize(@object)
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


