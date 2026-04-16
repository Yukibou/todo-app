require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'email が空の場合バリデーションエラーになること' do
      user = build(:user, email: '')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to be_present
    end

    it 'email が重複している場合バリデーションエラーになること' do
      create(:user, email: 'test@example.com')
      user = build(:user, email: 'test@example.com')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to be_present
    end
  end

  describe 'associations' do
    it 'has_many todos' do
      user = create(:user)
      todo1 = create(:todo, user: user)
      todo2 = create(:todo, user: user)

      expect(user.todos).to include(todo1, todo2)
      expect(user.todos.count).to eq(2)
    end
  end
end
