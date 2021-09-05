require 'rails_helper'

describe Link do
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
  end

  describe '#generate_shortned' do
    it 'creates a valid shortned url' do
      link.send(:generate_shortned)
      link.valid?

      expect(link.errors.details[:shortned]).to be_empty
    end

    it 'runs about to save' do
      expect(link).to receive(:generate_shortned)
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
end
