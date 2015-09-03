class Monster < ActiveRecord::Base
  validates :name, :power, :element_type, :user_id, presence: true
  validates_numericality_of :power

  belongs_to :user
  belongs_to :team

  validates_each :user do |record, attr, value|
    record.errors.add attr, "too much monsters for user" if record.user.monsters.length >= 20
  end
end
