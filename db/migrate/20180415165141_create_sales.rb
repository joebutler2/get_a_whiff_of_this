class CreateSales < ActiveRecord::Migration[5.2]
  def change
    create_table :sales do |t|
      t.date :date
      t.decimal :cost

      t.timestamps
    end
  end
end
