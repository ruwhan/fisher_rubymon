class Team < ActiveRecord::Base
  validates :name, presence: true
  
  belongs_to :user
  has_many :monsters, :dependent => :nullify

  accepts_nested_attributes_for :monsters

  validates_each :user do |record, attr, value|
    record.errors.add attr, "too much team for users" if record.user.teams.length >= 3
  end
end
