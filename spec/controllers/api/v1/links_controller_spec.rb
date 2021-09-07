require 'rails_helper'

RSpec.describe Api::V1::LinksController, type: :controller do
  let(:valid_original_url) { 'https://gapfish.com' }
  let(:invalid_url) { 'zzz://localhost:4567/' }
  let(:valid_attributes) do
    { original: valid_original_url }
  end

  let(:invalid_attributes) do
    { original: invalid_url }
  end

  let(:valid_session) { {} }
  let(:link) { create(:link, valid_attributes) }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    let!(:old_access_count) { link.access_count }

    before do
      get :show, params: { id: link.to_param }, session: valid_session
    end

    it 'returns a retirect status code' do
      expect(response.code).to eq('302')
    end

    it 'returns a redirect response' do
      expect(response).to redirect_to(link.original)
    end

    it 'increments the access_count' do
      link.reload
      new_count = old_access_count + 1

      expect(new_count).to eq(link.access_count)
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Link' do
        expect do
          post :create, params: { link: valid_attributes }, session: valid_session
        end.to change(Link, :count).by(1)
      end

      it 'redirects to the created link' do
        post :create, params: { link: valid_attributes }, session: valid_session
        expect(response).to redirect_to(api_v1_link_url(Link.last))
      end

      it 'sets no user id without being authenticated' do
        post :create, params: { link: valid_attributes }, session: valid_session
        expect(Link.last.user_id).to eq(nil)
      end

      context 'with a logged in user' do
        let(:user) { create(:user) }

        before do
          sign_in(user)
        end

        it 'sets the correct user id after being authenticated' do
          post :create, params: { link: valid_attributes }, session: valid_session
          expect(Link.last.user_id).to eq(user.id)
        end
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { link: invalid_attributes }, session: valid_session
        expect(response).to_not be_successful
      end
    end
  end
end