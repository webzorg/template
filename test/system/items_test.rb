# frozen_string_literal: true

require "application_system_test_case"

class ItemsTest < ApplicationSystemTestCase
  test "visiting the index" do
    visit items_url(locale: :ka)

    library_items_index_with_query

    library_items_index_with_query(search_query: "ლე") do
      assert_texts ["ბაყაყები", "არისტოფანე", "იფიგენია ავლისში", "ევრიპიდე", "არგონავტების თქმულება", "შტაინერი"]
    end

    library_items_index_with_query(search_query: "ლევა") do
      assert_texts ["ბაყაყები", "არისტოფანე", "იფიგენია ავლისში", "ევრიპიდე"]
    end

    library_items_index_with_query do
      find("button.btn i.fas.fa-undo").click
    end
  end

  test "visiting the index and show" do
    visit items_url(locale: :ka)

    items = library_items_index_with_query(search_query: "არისტ") do
      assert_texts ["ევდემოსის ეთიკა", "არისტოტელე", "ბაყაყები", "არისტოფანე"]
    end

    library_item = Item.find_by(title: "ბაყაყები")

    click_on library_item.title
    assert_current_path item_path(locale: :ka, id: library_item)
    assert_selector "h2", text: "ბაყაყები"
    assert_texts ["ავტორი", "მთარგმნელი", "ლევან ბერძენიშვილი", "გამომცემლობა", "არილი", "ფაილები", "11"]

    click_on "დაბრუნება"

    library_items_index_with_query(search_query: nil) do
      assert_texts ["ევდემოსის ეთიკა", "არისტოტელე", "ბაყაყები", "არისტოფანე"]

      assert_selector "div.row a.card", count: items.count
      assert_selector ".row img", count: items.count
    end
  end

  private

    def library_items_index_with_query(search_query: "")
      assert_selector "h3", text: "საბიბლიოთეკო ერთეულების ძებნა"
      assert_selector "input#query"

      unless search_query.nil?
        items = filter_public_library_items_by(search_query)
        fill_in "query", with: search_query if search_query.present?
      end

      yield if block_given?

      if search_query.present?
        # assert_current_path "/library/items?q[attributes_i_cont]=#{search_query}"
        assert_current_path items_path(locale: :ka, q: { attributes_i_cont: search_query })
      else
        assert_current_path items_path(locale: :ka)
      end

      if items
        assert_selector "div.row a.card", count: items.count
        assert_selector ".row img", count: items.count
      end

      items
    end

    def filter_public_library_items_by(query)
      Item.with_attached_cover.publicly_available.ransack(attributes_i_cont: query).result
    end
end
