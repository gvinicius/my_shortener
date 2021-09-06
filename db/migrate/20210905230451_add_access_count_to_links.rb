class AddAccessCountToLinks < ActiveRecord::Migration[6.1]
  def change
    add_column :links, :access_count, :integer, default: 0
  end
end
