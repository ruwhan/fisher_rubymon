require 'rails_helper'

RSpec.describe Team, type: :model do
  before { @team = FactoryGirl.build(:team) }
  subject { @team }

  # we test the user model actually respond to this attributes
  it { should respond_to(:name) }

  it { should be_valid }

  it { should validate_presence_of(:name) }

  it { should have_many(:monsters) }
  it { should belong_to(:user) }

  describe "#monsters association" do 
    before do 
      @team.save

      5.times { FactoryGirl.create(:monster, team: @team) }
    end

    it "should nullify the monster's team_id" do 
      monsters = @team.monsters
      @team.destroy

      monsters.each do |monster|
        expect(Monster.find(monster).team_id).to eql nil 
      end
    end
  end

  describe "#save multiple" do 
    before do 
      @user = FactoryGirl.create(:user) do |user|
        3.times { user.teams.create(FactoryGirl.attributes_for(:team)) }
      end
    end

    it "fail for 4th monster" do 
      team = FactoryGirl.build(:team, user: @user)
      p @user.teams.length
      expect(team.save).to eql false
    end
  end
end
