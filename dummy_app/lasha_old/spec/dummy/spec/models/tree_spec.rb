require "rails_helper"

RSpec.describe Tree, type: :model do
  let(:trees) { create_list(:tree, 150) }

  it "creates multiple trees" do
    expect(trees.count).to eq(150)
  end
end
