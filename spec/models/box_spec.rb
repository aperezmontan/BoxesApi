# frozen_string_literal: true

require 'rails_helper'

describe ::Box do
  let(:game) { create(:game) }
  let(:user) { create(:user) }
  let(:sheet) { ::Sheet.start_new_sheet(:name => 'new sheet', :game => game, :user => user) }

  subject { described_class.create!(:number => 1) }

  it 'cannot be created on its own (must be created by sheet)' do
    expect { subject }.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Sheet must exist')
  end

  context 'associations' do
    subject do
      sheet.save
      sheet.boxes.sample
    end

    it '#sheet' do
      expect(subject.sheet).to eq(sheet)
    end

    it 'must belong to a sheet' do
      subject
      expect { subject.update_attributes!(:sheet_id => nil) }.to raise_error(ActiveRecord::RecordNotSaved)
    end

    it '#user' do
      expect(subject.user).to eq(user)
    end

    it 'can be owned' do
      subject.owner = create(:user)
      expect(subject.valid?).to eq(true)
    end
  end

  context 'validations' do
    subject do
      sheet.save
      sheet.boxes.sample
    end

    it 'can only be deleted when its sheet is deleted' do
      expect { subject.destroy! }.to raise_error(ActiveRecord::RecordNotDestroyed)
    end

    it 'can only be deleted when a sheet its deleted' do
      subject.sheet.destroy
      expect(subject.destroyed?).to eq(true)
    end
  end
end
