require 'rails_helper'

RSpec.describe User, type: :model do
  before { @user = FactoryGirl.build(:user) }

  subject { @user }

  # we test the user model actually respond to this attributes
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:auth_token) }
  it { should respond_to(:uid) }
  it { should respond_to(:provider) }

  it { should be_valid }

  it { should validate_presence_of(:email)  }
  it { should validate_uniqueness_of(:email) }
  it { should validate_confirmation_of(:password) }
  it { should allow_value('example@domain.com').for(:email) }

  it { should validate_uniqueness_of(:auth_token) }

  it { should have_many(:monsters) }
  it { should have_many(:teams) }

  describe "#generate_authentication_token!" do 
    it "generates_authentication_token" do 
      Devise.stub(:friendly_token).and_return("auniquetoken123")
      @user.generate_authentication_token!
      expect(@user.auth_token).to eql "auniquetoken123"
    end

    it "generates another token when one already has been taken" do 
      existing_user = FactoryGirl.create(:user, auth_token: "auniquetoken123")
      @user.generate_authentication_token!
      expect(@user.auth_token).not_to eql existing_user.auth_token 
    end
  end

  describe "#from_facebook" do 
    it "return existing related user" do 
      existing_user = FactoryGirl.create(:user, :provider => 'facebook')
      user_from_facebook = User.from_facebook({ uid: existing_user.uid })
      expect(user_from_facebook.email).to eql existing_user.email
    end
  end

  describe "#monsters association" do 
    before do
      @user.save
      20.times { FactoryGirl.create :monster, user: @user }
    end

    it "destroys the associated monsters on self destruct" do 
      monsters = @user.monsters
      @user.destroy

      monsters.each do |monster|
        expect(Monster.find(monster)).to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "#teams association" do 
    before do 
      @user.save
      3.times { FactoryGirl.create :team, user: @user }
    end

    it "destroys the associated teams on self destruct" do 
      teams = @user.teams
      @user.destroy 

      teams.each do |team|
        expect(Team.find(team)).to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
