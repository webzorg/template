describe "table builder", type: :system do
  let(:admin_user) { u = create(:user); u.add_role(:admin); u.confirm; u }
  let(:users) { create_list(:user, 150) }

  before(:each) do
    visit "login"

    fill_in "Email",    with: admin_user.email
    fill_in "Password", with: "123456"
    click_on "Log in"
  end

  it "index page returns correct data" do
    expect(users.count).to equal(150)

    visit "admin/users"

    # check title
    expect(page).to have_content "User Index"

    # # pagination
    expect(all(".pagination")[0].all("li").count).to eq(9)  # top pagination
    expect(all(".pagination")[1].all("li").count).to eq(9)  # bot pagination

    # # number of rows
    expect(all("table thead tr").count).to eq(1)  # head row
    expect(all("table tbody tr").count).to eq(10) # body rows
  end
end
