require 'rails_helper'

RSpec.describe Api::V1::TeamsController, type: :controller do
  describe "GET #show" do 
    before(:each) do 
      @team = FactoryGirl.create :team 
      request.headers["Authorization"] = @team.user.auth_token
      get :show, { id: @team.id, user_id: @team.user.id }, format: :json
    end

    it "returns the information about a team on a hash" do 
      team_response = JSON.parse(response.body, symbolize_names: true)
      expect(team_response[:team][:name]).to eql @team.name
    end

    it { should respond_with 200 }
  end

  describe "GET #index" do 
    before(:each) do 
      user = FactoryGirl.create :user 
      3.times { FactoryGirl.create(:team, user: user) }
      request.headers["Authorization"] = user.auth_token
      get :index
    end

    it "returns 3 records from the database" do 
      teams_response = JSON.parse(response.body, symbolize_names: true)
      expect(teams_response[:teams].length).to eql 3
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        user = FactoryGirl.create :user
        @team_attributes = FactoryGirl.attributes_for :team 
        request.headers["Authorization"] = user.auth_token
        post :create, { user_id: user.id, team: @team_attributes }
      end

      it "renders the json representation for the team record just created" do
        team_response = team_response = JSON.parse(response.body, symbolize_names: true)
        expect(team_response[:team][:name]).to eql @team_attributes[:name]
      end

      it { should respond_with 201 }
    end

    context "when is not created" do
      before(:each) do
        user = FactoryGirl.create :user
        @invalid_team_attributes = { name: "" }
        request.headers["Authorization"] = user.auth_token
        post :create, { user_id: user.id, team: @invalid_team_attributes }
      end

      it "renders an errors json" do
        team_response = team_response = JSON.parse(response.body, symbolize_names: true)
        expect(team_response).to have_key(:errors)
      end

      it "renders the json errors on why the team could not be created" do
        team_response = JSON.parse(response.body, symbolize_names: true)
        expect(team_response[:errors][:name]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

  describe "PUT/PATCH #update" do
    before(:each) do
      @user = FactoryGirl.create :user
      @team = FactoryGirl.create :team, user: @user
      @monsters = [FactoryGirl.create(:monster, user: @user)]

      # 3.times { @monsters << FactoryGirl.create(:monster, user: @user) }

      request.headers["Authorization"] = @user.auth_token
    end

    context "when is successfully updated" do
      before(:each) do
        patch :update, { user_id: @user.id, id: @team.id, team: { monster_ids: [ @monsters[0].id ] } }
      end

      it "renders the json representation for the updated user" do
        team_response = JSON.parse(response.body, symbolize_names: true)
        expect(team_response[:team][:monsters][0][:id]).to eql @monsters[0][:id]
      end

      it { should respond_with 200 }
    end

    context "when is not updated" do
      before(:each) do
        patch :update, { user_id: @user.id, id: @team.id,
              team: { name: "" } }
      end

      it "renders an errors json" do
        team_response = JSON.parse(response.body, symbolize_names: true)
        expect(team_response).to have_key(:errors)
      end

      it "renders the json errors on whye the user could not be created" do
        team_response = JSON.parse(response.body, symbolize_names: true)
        expect(team_response[:errors][:name]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end
  describe "PUT/PATCH #update" do
    before(:each) do
      @user = FactoryGirl.create :user
      @team = FactoryGirl.create :team, user: @user
      @monsters = [FactoryGirl.create(:monster, user: @user)]

      # 3.times { @monsters << FactoryGirl.create(:monster, user: @user) }

      request.headers["Authorization"] = @user.auth_token
    end

    context "when is successfully updated" do
      before(:each) do
        patch :update, { user_id: @user.id, id: @team.id, team: { monster_ids: [ @monsters[0].id ] } }
      end

      it "renders the json representation for the updated user" do
        team_response = JSON.parse(response.body, symbolize_names: true)
        expect(team_response[:team][:monsters][0][:id]).to eql @monsters[0][:id]
      end

      it { should respond_with 200 }
    end

    context "when is not updated" do
      before(:each) do
        patch :update, { user_id: @user.id, id: @team.id,
              team: { name: "" } }
      end

      it "renders an errors json" do
        team_response = JSON.parse(response.body, symbolize_names: true)
        expect(team_response).to have_key(:errors)
      end

      it "renders the json errors on whye the user could not be created" do
        team_response = JSON.parse(response.body, symbolize_names: true)
        expect(team_response[:errors][:name]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      user = FactoryGirl.create :user
      team = FactoryGirl.create :team, user: user
      request.headers["Authorization"] = user.auth_token
      delete :destroy, { user_id: user.id, id: team.id }
    end

    it { should respond_with 204 }
  end
end
