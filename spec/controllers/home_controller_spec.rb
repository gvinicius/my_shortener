require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  describe "GET #landing" do
    it "returns http success" do
      get :landing
      expect(response.code).to eq('302')
    end
  end

end