require 'rails_helper'

RSpec.describe Monster, type: :model do
  let(:monster) { FactoryGirl.build :monster }
  subject { monster }

  it { should respond_to(:name) }
  it { should respond_to(:power) }
  it { should respond_to(:element_type) }
  it { should respond_to(:user_id) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:power) }
  it { should validate_numericality_of(:power) }
  it { should validate_presence_of(:element_type) }

  # TODO: strict type test to fire, water, earth, electric, wind

  it { should belong_to :user }
  it { should belong_to :team }

  describe "#save multiple" do 
    # before do 
    #   @user = FactoryGirl.create(:user) do |user|
    #     20.times { user.monsters.create(FactoryGirl.attributes_for(:monster)) }
    #   end
    # end

    it "success for 20nd monster" do 
      @user = FactoryGirl.create(:user) do |user|
        19.times { user.monsters.create(FactoryGirl.attributes_for(:monster)) }
      end
      monster = FactoryGirl.build(:monster, user: @user)
      expect(monster.save).to eql true
    end

    it "fail for 21st monster" do 
      @user = FactoryGirl.create(:user) do |user|
        20.times { user.monsters.create(FactoryGirl.attributes_for(:monster)) }
      end
      monster = FactoryGirl.build(:monster, user: @user)
      expect(monster.save).to eql false
    end
  end
end
