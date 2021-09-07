# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Link, type: :model do
  let(:link) do
    build(:link)
  end
  let(:empty_url) { '' }
  let(:valid_suffix) { 'guhaig' }
  let(:valid_number_to_be_appended) { '9' }
  let(:invalid_url) { 'zzz://localhost:4567/' }
  let(:valid_original_url) { 'https://gapfish.com' }
  let(:valid_shortned_url) do
    "https://localhost:4567/#{valid_suffix}#{valid_number_to_be_appended}"
  end

  context 'when creating a link' do
    let(:some_user_id) { 1 }
    it { is_expected.to respond_to(:original) }
    it { is_expected.to respond_to(:shortned) }
    it { is_expected.to respond_to(:access_count) }
    it { is_expected.to respond_to(:user_id) }

    it 'is invalid without an original value' do
      link.original = empty_url

      expect(link).to_not be_valid
    end

    it 'is invalid without a shortned value' do
      link.original = empty_url
      link.shortned = empty_url

      expect(link).to_not be_valid
    end

    it 'is invalid without a valid url for the original value' do
      link.original = invalid_url

      expect(link).to_not be_valid
    end

    it 'is invalid without a valid url for the shortned value' do
      link.shortned = invalid_url

      expect(link).to_not be_valid
    end

    it 'is valid with a valid original url and a valid shortned one' do
      link.original = valid_original_url
      link.shortned = valid_shortned_url
      link.save

      expect(link).to be_valid
    end

    it 'is valid with no user associated' do
      link.user_id = nil

      expect(link.errors.details[:user_id]).to be_empty
    end

    it 'is valid with a user associated' do
      link.user_id = some_user_id

      expect(link.errors.details[:user_id]).to be_empty
    end
  end

  describe '#generate_shortned' do
    it 'creates a valid shortned url' do
      link.send(:generate_shortned)
      link.valid?

      expect(link.errors.details[:shortned]).to be_empty
    end

    it 'runs about to save and it is a new entry' do
      expect(link).to receive(:generate_shortned)
      link.shortned = ''
      link.original = valid_original_url

      link.save
    end

    it 'does not run about to save because it is not a new entry' do
      expect(link).to_not receive(:generate_shortned)
      link.original = valid_original_url

      link.save
    end

    context 'given controlled situations' do
      before do
        allow(SecureRandom).to receive(:alphanumeric).with(described_class::ALPHANUMERIC_LENGTH).and_return(valid_suffix)
        allow(SecureRandom).to receive(:random_number).with(described_class::NUMBER_LENGTH).and_return(valid_number_to_be_appended)
      end

      it 'builds a valid url following a precise example' do
        link.send(:generate_shortned)

        expect(link.shortned).to eq(valid_shortned_url)
      end
    end

    context 'dealing with repetitions' do
      let(:another_link) { create(:link, original: valid_original_url, shortned: valid_shortned_url) }

      it 'changes the url to avoid repetitions' do
        link.shortned = another_link.shortned
        link.original = another_link.original
        link.save

        expect(link.shortned).to_not eq(another_link.shortned)
      end
    end
  end

  describe '#increment_access_count' do
    let(:link) { create(:link, original: valid_original_url, shortned: valid_shortned_url) }

    it 'increments the count' do
      expect { link.increment_access_count }.to change { link.access_count }.from(0).to(1)
    end
  end
end
