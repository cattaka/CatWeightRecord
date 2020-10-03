class CreateWeightEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :weight_events do |t|
      t.string :label
      t.references :image_file, foreign_key: true

      t.timestamps
    end
  end
end
