class AddOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.text :raw_text
      t.string :email

      t.timestamps
    end
  end
end
