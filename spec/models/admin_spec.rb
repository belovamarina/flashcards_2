require 'rails_helper'

RSpec.describe Admin, type: :model do
  let(:user) { create(:user) }

  it 'not added by default' do
    user = create(:user)
    expect(user.has_role?(:admin)).to be_falsey
  end

  it 'role can be added' do
    user.add_role :admin
    expect(user.has_role?(:admin)).to be_truthy
  end

  it 'role can be removed' do
    user.add_role :admin
    user.remove_role :admin
    expect(user.has_role?(:admin)).to be_falsey
  end
end
