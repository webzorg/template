# frozen_string_literal: true

require "rails_helper"

RSpec.describe LashaMailer do
  let(:email) { LashaMailer.notify("destination@email.com", "subject", "body text") }

  it "renders the headers" do
    expect(email.subject).to eq("subject")
    expect(email.to).to      eq(["destination@email.com"])
    expect(email.from).to    eq(["from@email.com"])
  end

  it "renders the body" do
    expect(email.body.encoded).to match("body text")
  end
end
