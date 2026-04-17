require 'rails_helper'

RSpec.describe Todo, type: :model do
  describe 'validations' do
    it 'title が空の場合バリデーションエラーになること' do
      todo = build(:todo, title: '')
      expect(todo).not_to be_valid
      expect(todo.errors[:title]).to be_present
    end

    it 'assignee が空の場合バリデーションエラーになること' do
      todo = build(:todo, assignee: '')
      expect(todo).not_to be_valid
      expect(todo.errors[:assignee]).to be_present
    end
  end

  describe 'associations' do
    it 'user に紐づいていること' do
      user = create(:user)
      todo = create(:todo, user: user)

      expect(todo.user).to eq(user)
    end
  end

  describe 'default values' do
    it 'done のデフォルトが false であること' do
      todo = create(:todo)
      expect(todo.done).to be false
    end
  end
end
