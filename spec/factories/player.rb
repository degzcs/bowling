FactoryBot.define do
  factory :player do
    name { "Benito #{Player.count + 1}" }
  end
end
