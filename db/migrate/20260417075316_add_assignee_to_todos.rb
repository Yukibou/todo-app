class AddAssigneeToTodos < ActiveRecord::Migration[8.1]
  def change
    add_column :todos, :assignee, :string, null: false, default: ""
  end
end
