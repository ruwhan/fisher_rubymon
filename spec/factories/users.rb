FactoryGirl.define do
  factory :user do
    email { FFaker::Internet.email }
    uid { FFaker::IdentificationESCO.id }
    password "12345678"
    password_confirmation "12345678"
  end
end
