# frozen_string_literal: true

class Wow::EventSignupsController < ApplicationController
  def create
    @event_signup = Wow::EventSignup.find_or_initialize_by(
      calendar_event_id: params[:calendar_event_id],
      user: current_user
    )

    authorize(@event_signup)

    if @event_signup.update(object_params)
      redirect_to url_for(@event_signup.calendar_event), notice: "#{current_model.model_name.human} was successfully saved."
    else
      @data = Calendar::EventsController::CONFIG[:data].merge(
        model: Calendar::Event,
        object: @event_signup.calendar_event
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

      render "calendar/events/show"
    end
  end

  private

    def object_params
      params.permit(:status, :comment, :wow_character_id)
    end
end