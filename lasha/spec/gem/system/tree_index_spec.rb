describe "table builder", type: :system do
  let(:trees) { create_list(:tree, 150) }

  it "index page returns correct data" do
    expect(trees.count).to equal(150)

    visit "/trees"

    # check title
    expect(page).to have_content "Tree Index"

    # pagination
    expect(all(".pagination")[0].all("li").count).to eq(9)  # top pagination
    expect(all(".pagination")[1].all("li").count).to eq(9)  # bot pagination

    # number of rows
    expect(all("table thead tr").count).to eq(1)  # head row
    expect(all("table tbody tr").count).to eq(20) # body rows
  end
end
