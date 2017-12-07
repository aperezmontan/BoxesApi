# frozen_string_literal: true

require 'rails_helper'

describe ::Sheet do
  let(:game) { create(:game) }
  let(:user) { create(:user) }
  let(:sheet_params) do
    {
      :name => 'new_sheet',
      :user_id => user.id,
      :game_id => game.id
    }
  end
  let(:bad_sheet_params) { { :name => 'new_sheet', :game_id => game.id } }

  context '#start_new_sheet' do
    context 'when sheet has all the correct params' do
      it 'creates the Sheet' do
        expect { described_class.start_new_sheet(sheet_params).save }.to change { ::Sheet.count }.by(1)
      end

      it 'creates its Boxes' do
        expect { described_class.start_new_sheet(sheet_params).save }.to change { ::Box.count }.by(100)
      end
    end

    context "when sheet doesn't have all the correct params" do
      it "doesn't create the Sheet" do
        expect { described_class.start_new_sheet(bad_sheet_params).save }.to_not change(::Sheet, :count)
      end

      it "doesn't create its Boxes" do
        expect { described_class.start_new_sheet(bad_sheet_params).save }.to_not change(::Box, :count)
      end

      context 'errors' do
        context 'when Sheet is created with invalid params' do
          let(:invalid_params) do
            {
              :name => 'new_sheet',
              :game_id => game.id
            }
          end

          it "doesn't save and returns an invalid params error" do
            sheet = Sheet.start_new_sheet(invalid_params)
            expect { sheet.save! }.to raise_error(ActiveRecord::RecordInvalid)
          end
        end

        context 'when Sheet violates uniqueness constraint (game, user, name)' do
          before { Sheet.create(sheet_params) }

          it "doesn't save and return a not unique error" do
            sheet = Sheet.start_new_sheet(sheet_params)
            expect { sheet.save! }.to raise_error(ActiveRecord::RecordNotUnique)
          end
        end
      end
    end
  end
end
