# frozen_string_literal: true

require "application_system_test_case"

class HomesTest < ApplicationSystemTestCase
  test "visiting the home#index" do
    visit root_url

    assert_selector "h2", text: "პროექტი არესი"
  end

  test "visiting the home#contact" do
    visit contact_url

    assert_selector "h2", text: "კონტაქტი"
  end
end
