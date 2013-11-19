FactoryGirl.define do
  factory :user do
    name                  "Ian Root"
    email                 "ian@example.com"
    password              "foobar"
    password_confirmation "foobar"
  end  
end