class AddGravatarToUsers < ActiveRecord::Migration
  def self.up
    add_attachment :users, :profpic
  end

  def self.down
    remove_attachment :users, :profpic
  end
end
