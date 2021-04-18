# frozen_string_literal: true

require "application_system_test_case"

module Users
  class SignInAndSignUpsTest < ApplicationSystemTestCase
    test "sign_up / confirmation / sign_out flow" do
      visit new_user_registration_url(locale: :ka)
      assert_current_path new_user_registration_path(locale: :ka)

      assert_selector "input", count: 6
      assert_equal find_all("input").map { |i| i.native.attribute("validationMessage") }.count(&:present?), 5

      assert_difference -> { User.count } => 1, -> { ActionMailer::Base.deliveries.count } => 1 do
        fill_in "სახელი", with: "name"
        fill_in "გვარი", with: "lastname"
        fill_in "ელ-ფოსტა", with: "for_manual_registration@email.com"
        fill_in "პაროლი", with: "123456"
        fill_in "პაროლის დადასტურება", with: "123456"

        click_button "რეგისტრაცია"
      end

      assert_equal User.last.confirmed?, false

      visit confirmation_path

      assert_current_path root_path(locale: :ka)
      assert_text "თქვენი ელ-ფოსტა წარმატებულად დადასტურდა"
      assert_equal User.last.confirmed?, true

      click_on "name lastname"
      click_on "გამოსვლა"

      assert_selector "nav .container ul li", text: "რეგისტრაცია"
      assert_selector "nav .container ul li", text: "ავტორიზაცია"
    end

    test "sign_in / sign_out flow" do
      visit new_user_session_url(locale: :ka)
      assert_current_path new_user_session_path(locale: :ka)

      fill_in "ელ-ფოსტა", with: "for_login@email.com"
      fill_in "პაროლი", with: "123456"
      check "დამიმახსოვრე"
      click_button "ავტორიზაცია"

      assert_text "ავტორიზაცია წარმატებულია"

      assert_current_path root_path(locale: :ka)
      assert_selector "nav .container ul li", text: "for_login@email.com"

      click_on "for_login@email.com"
      click_on "გამოსვლა"

      assert_selector "nav .container ul li", text: "რეგისტრაცია"
      assert_selector "nav .container ul li", text: "ავტორიზაცია"
    end

    private

      def confirmation_path
        ActionMailer::Base
          .deliveries.find { |d| d.to.include? "for_manual_registration@email.com" }
          .body.match(%r{(?<=href="http://localhost:3000)(.*)(?=")}).to_s
      end
  end
end
