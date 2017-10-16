FactoryGirl.define do
  factory :block do
    title 'Block 1'
    user

    trait :with_one_card do
      after(:create) do |instance|
        create_list(:card, 1, block: instance, user: instance.user)
      end
    end

    trait :with_two_cards do
      after(:create) do |instance|
        create_list(:card, 2, block: instance, user: instance.user)
      end
    end
  end
end
