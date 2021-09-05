class CreateLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :links do |t|
      t.text :original
      t.text :shortned

      t.timestamps
    end
  end
end
