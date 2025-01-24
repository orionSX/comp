class CreateComputers < ActiveRecord::Migration[8.0]
  def change
    create_table :computers do |t|
      t.string :name
      t.string :video_card
      t.string :cpu
      t.string :motherboard
      t.string :monitor
      t.string :keyboard
      t.string :mouse
      t.decimal :price_per_hour

      t.timestamps
    end
  end
end
