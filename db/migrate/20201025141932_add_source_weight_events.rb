class AddSourceWeightEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :weight_events, :source, :string
  end
end
