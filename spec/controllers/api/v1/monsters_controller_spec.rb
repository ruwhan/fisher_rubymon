require 'rails_helper'

RSpec.describe Api::V1::MonstersController, type: :controller do


  describe "GET #show" do 
    before(:each) do 
      @monster = FactoryGirl.create :monster
      request.headers["Authorization"] = @monster.user.auth_token
      get :show, { id: @monster.id, user_id: @monster.user.id }, format: :json
    end

    it "returns the information about a monster on a hash" do 
      monster_response = JSON.parse(response.body, symbolize_names: true)
      expect(monster_response[:monster][:name]).to eql @monster.name
      expect(monster_response[:monster][:user][:id]).to eql @monster.user.id
    end

    it { should respond_with 200 }
  end

  describe "get #index" do 
    before(:each) do 
      user = FactoryGirl.create :user 
      4.times { FactoryGirl.create(:monster, user: user) }
      request.headers["Authorization"] = user.auth_token
      get :index
    end

    it "returns 4 records from the database" do 
      monster_response = JSON.parse(response.body, symbolize_names: true)
      # puts monster_response.to_s
      expect(monster_response[:monsters].length).to eql 4
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        user = FactoryGirl.create :user
        @monster_attributes = FactoryGirl.attributes_for :monster
        request.headers["Authorization"] = user.auth_token
        post :create, { user_id: user.id, monster: @monster_attributes }
      end

      it "renders the json representation for the monster record just created" do
        monster_response = monster_response = JSON.parse(response.body, symbolize_names: true)
        expect(monster_response[:monster][:name]).to eql @monster_attributes[:name]
      end

      it { should respond_with 201 }
    end

    context "when is not created" do
      before(:each) do
        user = FactoryGirl.create :user
        @invalid_monster_attributes = { name: "Monster 1", power: "Ten" }
        request.headers["Authorization"] = user.auth_token
        post :create, { user_id: user.id, monster: @invalid_monster_attributes }
      end

      it "renders an errors json" do
        monster_response = monster_response = JSON.parse(response.body, symbolize_names: true)
        expect(monster_response).to have_key(:errors)
      end

      it "renders the json errors on whye the user could not be created" do
        monster_response = JSON.parse(response.body, symbolize_names: true)
        expect(monster_response[:errors][:power]).to include "is not a number"
      end

      it { should respond_with 422 }
    end
  end

  describe "PUT/PATCH #update" do
    before(:each) do
      @user = FactoryGirl.create :user
      @monster = FactoryGirl.create :monster, user: @user
      request.headers["Authorization"] = @user.auth_token
    end

    context "when is successfully updated" do
      before(:each) do
        patch :update, { user_id: @user.id, id: @monster.id,
              monster: { name: "Fire Monster" } }
      end

      it "renders the json representation for the updated user" do
        monster_response = JSON.parse(response.body, symbolize_names: true)
        expect(monster_response[:monster][:name]).to eql "Fire Monster"
      end

      it { should respond_with 200 }
    end

    context "when is not updated" do
      before(:each) do
        patch :update, { user_id: @user.id, id: @monster.id,
              monster: { power: "one hundred" } }
      end

      it "renders an errors json" do
        monster_response = JSON.parse(response.body, symbolize_names: true)
        expect(monster_response).to have_key(:errors)
      end

      it "renders the json errors on whye the user could not be created" do
        monster_response = JSON.parse(response.body, symbolize_names: true)
        expect(monster_response[:errors][:power]).to include "is not a number"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      @monster = FactoryGirl.create :monster, user: @user
      request.headers["Authorization"] = @user.auth_token
      delete :destroy, { user_id: @user.id, id: @monster.id }
    end

    it { should respond_with 204 }
  end
end
