FactoryGirl.define do
  factory :team do
    name { FFaker::Name.name }
    user
  end

end
