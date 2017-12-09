# frozen_string_literal: true

shared_context 'new sheet' do
  let(:owner) { create(:user) }
  let(:game) { create(:game) }
  let(:sheet_params) do
    {
      :name => 'new_sheet',
      :user_id => owner.id,
      :game_id => game.id
    }
  end
  let!(:sheet) do
    sheet = ::Sheet.start_new_sheet(sheet_params)
    sheet.save
    sheet
  end
  let!(:box) { sheet.boxes.sample }
end
