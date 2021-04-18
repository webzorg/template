# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "sidekiq/testing"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    Sidekiq::Testing.inline!
  end
end

module MiniTest
  module Assertions
    def assert_texts(texts)
      texts.map { |text| assert_text(text) }.all?
    end
  end
end
