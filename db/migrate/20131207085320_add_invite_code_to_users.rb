class AddInviteCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :invite_code, :string
    add_index  :users, :invite_code
  end
end
