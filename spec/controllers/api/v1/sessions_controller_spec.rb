require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do

  describe "POST #create" do 
    before(:each) do 
      @user = FactoryGirl.create :user
    end

    context "when credentials are correct" do 
      before(:each) do 
        credentials = { email: @user.email, password: "12345678" }
        post :create, { session: credentials }
      end

      it "returns the user record corresponding to the given credentials" do 
        @user.reload
        sessions_response = JSON.parse(response.body, symbolize_names: true)
        expect(sessions_response[:user][:email]).to eql @user.email
      end

      it { should respond_with 200 }
    end

    context "when credentials are incorrect" do 
      before(:each) do 
        credentials = { email: @user.email, password: "invalidpassword" }
        post :create, { session: credentials }
      end

      it "returns a json with an error" do 
        sessions_response = JSON.parse(response.body, symbolize_names: true)
        expect(sessions_response[:errors]).to eql "Invalid email or password"
      end

      it { should respond_with 422 }
    end

    context "when user is not exist" do 
      before do 
        post :create, { session: { email: 'user1@fake.dom', password: 'randompassword' } }
      end

      it "returns an error" do 
        sessions_response = JSON.parse(response.body, symbolize_names: true)
        expect(sessions_response[:errors]). to eql "User is not exist"
      end

      it { should respond_with 422 }
    end
  end

  # describe "DELETE #destroy" do 

  # end
end
