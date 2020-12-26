# frozen_string_literal: true

require "rails/generators/resource_helpers"

module Rails
  module Generators
    class LashaAssetsGenerator < NamedBase # :nodoc:
      source_root File.expand_path("templates", __dir__)

      argument :actions, type: :array, default: [], banner: "action action"

      def create_controller_dir
        empty_directory(controller_path) unless File.directory?(controller_path)
      end

      def copy_controller_file
        if actions.present?
          actions.each do |action|
            @action = action
            template("controller.js", controller_path.join("#{action}_controller.js"))
          end
        else
          template("controller.js", "#{controller_path}.js")
        end
      end

      # def copy_stylesheet_file
      #   template("controller.sass", stylesheet_path.join("#{file_name.pluralize}.sass"))
      # end

      private

      def controller_path
        Rails.root.join("app", "javascript", "controllers", file_name.pluralize)
      end

      def stylesheet_path
        Rails.root.join("app", "assets", "stylesheets")
      end
    end
  end
end

