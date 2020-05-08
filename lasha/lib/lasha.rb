require "lasha/engine"
require "slim-rails"
require "sassc-rails"
require "pagy"
require "ransack"
require "aasm"
require "active_link_to"
require "devise"
require "devise_token_auth"
require "devise-async"
require "rolify"
require "devise-i18n"
require "rails-i18n"
require "omniauth-facebook"
require "omniauth-google-oauth2"
require "pundit"
require "autoprefixer-rails"
require "redis"
require "hiredis"
require "sidekiq"
require "sidekiq-cron"
require "sidekiq-failures"
require "sitemap_generator"
require "image_processing"

module Lasha
  INDEX_ACTIONS = %i[new show edit destroy].freeze
  READ_ONLY_ATTRIBUTES = %w[id created_at updated_at].freeze

  class << self
    def setup_data(
      controller:,
      namespace: nil,
      model:     nil,
      actions:   nil,
      collection:,
      attributes:,
      pagy_items: 20,
      scope_filters: false
    )
      data_hash = {
        namespace: set_or_guess_namespace(namespace, controller),
        model: set_or_guess_model(model, collection),
        collection: collection,
        attributes: attributes.with_indifferent_access,
        attributes_index: attributes.reject { |_key, value| value[:skip_index] }.keys,
        actions: set_or_guess_actions(actions, controller),
        scope_filters: scope_filters
      }

      # @object setter if it is defined
      data_hash[:object] = controller.instance_variable_get(:@object) if controller.instance_variable_defined?(:@object)

      data_hash[:object] = data_hash[:model].send(:new) if controller.action_name.to_sym == :new

      validate_index_data(**data_hash)

      # Ransack
      data_hash[:ransack]    = collection.ransack(controller.params[:q])
      data_hash[:collection] = data_hash[:ransack].result

      # Pagy
      controller.class.send(:include, Pagy::Backend)
      data_hash[:pagy], data_hash[:collection] =
        controller.send(
          :pagy, data_hash[:collection], items: pagy_items
        )

      controller.data = data_hash
      # rescue ArgumentError => e
      #   puts "******** index_data argument error report"
      #   puts "Class:   #{e.class}"
      #   puts "Message: #{e.message}"
      #   puts e.backtrace
    end

    private

      def set_or_guess_namespace(namespace, controller)
        if namespace.present?
          namespace
        elsif controller.class.name.include?("::")
          controller.class.name.deconstantize.underscore.to_sym
        end
      end

      def set_or_guess_model(model, collection)
        if model.present?
          model
        else
          collection.klass
        end
      end

      def set_or_guess_actions(actions, controller)
        if actions.present?
          actions
        else
          INDEX_ACTIONS & controller.action_methods.to_a.map(&:to_sym)
        end
      end

      def validate_index_data(**data_hash)
        data_hash.each do |key, value|
          case key
          # when :collection
          #   next if value.present?

          #   raise_args_error("Collection cannot be blank")
          # when :attributes
          when :model
            next if value.present?

            raise_args_error("Model cannot be deduced")
          when :actions
            next if (value - INDEX_ACTIONS).blank?

            raise_args_error("Uknown index action supplied")
            # when :namespace
          end
        end
      end

      def raise_args_error(message)
        raise ArgumentError, message
      end
  end
end
