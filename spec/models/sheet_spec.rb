require 'rails_helper'

describe ::Sheet do
  let(:sheet_params) { { :home_team => "NY", :away_team => "NJ" } }

  it "creates its Boxes" do
    expect{ described_class.create(sheet_params) }.to change{ ::Box.count }.by(100)
  end
end