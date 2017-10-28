FactoryBot.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  factory :user do
    email
    password '12345'
    password_confirmation '12345'
    locale 'ru'
    current_block_id ''

    trait :with_blocks do
      transient do
        count 1
      end

      after(:create) do |user, evaluator|
        create_list(:block, evaluator.count, user: user)
      end
    end

    trait :with_blocks_and_card do
      transient do
        count 1
      end

      after(:create) do |user, evaluator|
        create_list(:block, evaluator.count, :with_one_card, user: user)
      end
    end

    trait :with_blocks_and_cards do
      transient do
        count 1
      end

      after(:create) do |user, evaluator|
        create_list(:block, evaluator.count, :with_two_cards, user: user)
      end
    end

    factory :user_admin do
      after(:create) do |user|
        user.add_role :admin
      end
    end
  end
end
