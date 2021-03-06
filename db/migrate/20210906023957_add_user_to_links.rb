# frozen_string_literal: true

class AddUserToLinks < ActiveRecord::Migration[6.1]
  def change
    add_reference :links, :user, null: true, foreign_key: true
  end
end
