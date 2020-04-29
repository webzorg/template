module Lasha
  module ControllerBase
    extend ActiveSupport::Concern

    include Pundit
    include Pagy::Backend

    included do
      # TODO pending potential removal
      # prepend_before_action { @data ||= {} }
      attr_accessor :data

      rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
      after_action :verify_authorized, unless: :devise_controller?

      helper_method :current_model
      helper_method :current_collection

      before_action :set_locale
      before_action :record_user_activity, if: -> { user_signed_in? }
    end

    def authenticate_user!
      user_signed_in? ? super : not_found
    end

    def current_model(return_type=:class)
      case return_type
      when :class
        controller_name.classify.constantize
      when :symbol
        controller_name.singularize.to_sym
      when :string
        controller_name.singularize
      else
        raise "current_model was given a wrong return type"
      end
    end

    def current_collection(collection=current_model.all.order(created_at: :desc))
      if action_name.to_sym.eql?(:index)
        collection
      else
        current_model.none
      end
    end

    private

      def not_found
        render file: Rails.root.join("public", "404.html"), status: 404, layout: false
      end

      def user_not_authorized
        flash[:alert] = I18n.t(:not_authorized)
        redirect_to(request.referer || root_path)
      end

      def set_locale
        I18n.locale = params[:locale] || session[:locale] || I18n.default_locale
        session[:locale] = I18n.locale
      end

      def default_url_options(options = {})
        { locale: I18n.locale }.merge options
      end

      def record_user_activity
        current_user.touch(:last_activity_at)
      end
  end
end
