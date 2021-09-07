require 'rails_helper'

RSpec.describe "Redirections", type: :request do
  let(:valid_original_url) { 'https://gapfish.com' }
  let(:valid_attributes) do
    { original: valid_original_url, shortned: '' }
  end
  let(:link) { create(:link, valid_attributes) }

  describe "a call to the shortned link redirects to the original one" do
    before do
      get link.shortned
    end

    it "for new certification form" do
      expect(response).to redirect_to("#{api_v1_links_url}/#{link.id}")
    end
  end

  describe "a call to the shortned link redirects to the original one" do
   let!(:old_access_count) { link.access_count }
    before do
      get "#{api_v1_links_url}/#{link.id}"
    end

    it "for new certification form" do
      expect(response).to redirect_to(link.original)
    end

    it 'increments the access_count' do
      link.reload
      new_count = old_access_count + 1

      expect(new_count).to eq(link.access_count)
    end
  end
end
