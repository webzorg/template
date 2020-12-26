class Admin::UsersController < Admin::ApplicationController
  before_action :set_object, only: %i[show]
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
        first_name: {},
        last_name: {},
        company_name: {
          skip_index: true
        },
        phone_number: {
          skip_index: true
        },
        provider: {
          skip_index: true
        },
        uid: {
          skip_index: true
        },
        name: {
          skip_index: true
        },
        image: {
          skip_index: true
        },
        email: { },
        # encrypted_password
        # reset_password_token
        reset_password_sent_at: {
          skip_index: true
        },
        remember_created_at: {
          skip_index: true
        },
        sign_in_count: {},
        current_sign_in_at: {
          skip_index: true
        },
        last_sign_in_at: {
          skip_index: true
        },
        current_sign_in_ip: {
          skip_index: true
        },
        last_sign_in_ip: {
          skip_index: true
        },
        # confirmation_token
        confirmed_at: {
          skip_index: true
        },
        confirmation_sent_at: {
          kip_index: true
        },
        unconfirmed_email: {
          skip_index: true
        },
        failed_attempts: {
          skip_index: true
        },
        # unlock_token
        locked_at: {
          skip_index: true
        },
        created_at: {
          skip_index: true
        },
        updated_at: {
          skip_index: true
        },
        last_activity_at: {
          skip_index: true
        },
        # address: {
        #   skip_index: true
        # },
        # phone_number_verified: {
        #   skip_index: true
        # },
        # sms_verification_code
        # sms_last_sent: {
        #   skip_index: true
        # }
      },
      pagy_items: 10,
      scope_filters: true,
      search_fields: %i[attributes]
    },
    strong_params: %i[]
  }

  def index
  end

  def show
  end

  private

    def current_collection
      User.all
    end

    def current_model
      User
    end

    def set_object
      @object = current_model.public_send(:find, params[:id])
    end
end


