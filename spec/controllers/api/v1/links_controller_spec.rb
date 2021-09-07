# frozen_string_literal: true

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
  let(:user) { create(:user) }

  describe 'GET #index' do
    before do
      create(:link, valid_attributes)
      create_list(:link, 3, original: valid_original_url, user: user)
    end

    it 'returns a success response' do
      get :index, params: {}, session: valid_session, format: :json
      expect(response).to be_successful
    end

    context 'counting results' do
      render_views

      it 'returns a success response' do
        get :index, params: {}, session: valid_session, format: :json
        expect(JSON.parse(response.body).count).to eq(4)
      end
    end

    context 'with a logged in user' do
      before do
        sign_in(user)
      end

      context 'counting results' do
        render_views

        it 'returns the results only by the current user' do
          get :index, params: {}, session: valid_session, format: :json
          expect(JSON.parse(response.body).count).to eq(3)
        end
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Link' do
        expect do
          post :create, params: { link: valid_attributes }, session: valid_session, format: :json
        end.to change(Link, :count).by(1)
      end

      it 'redirects to the created link' do
        post :create, params: { link: valid_attributes }, session: valid_session, format: :json
        expect(response.code).to eq('201')
      end

      it 'sets no user id without being authenticated' do
        post :create, params: { link: valid_attributes }, session: valid_session, format: :json
        expect(Link.last.user_id).to eq(nil)
      end

      context 'with a logged in user' do
        before do
          sign_in(user)
        end

        it 'sets the correct user id after being authenticated' do
          post :create, params: { link: valid_attributes }, session: valid_session, format: :json
          expect(Link.last.user_id).to eq(user.id)
        end
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { link: invalid_attributes }, session: valid_session, format: :json
        expect(response).to_not be_successful
      end
    end
  end
end
