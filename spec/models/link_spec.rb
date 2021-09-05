require 'rails_helper'

describe Link do
  let(:link) do
    build(:link)
  end

  describe 'when creating a link' do
    let(:empty_url) { '' }
    let(:invalid_url) { 'zzz://localhost:4567/guhaig9' }
    let(:valid_original_url) { 'https://gapfish.com' }
    let(:valid_shortned_url) { 'https://localhost:4567/guhaig9' }

    it 'is invalid without an original value' do
      link.original = empty_url

      expect(link).to_not be_valid
    end

    it 'is invalid without a shortned value' do
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
end
