FactoryGirl.define do
  factory :monster do
    name { FFaker::Name.name }
    power { rand() * 100 }
    element_type "fire"
    user
  end

end
