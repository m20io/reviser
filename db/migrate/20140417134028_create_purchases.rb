class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.decimal :total_amount, precision: 8, scale: 2
      t.string :description
      t.string :state
      t.datetime :creation_date
      t.datetime :approval_date
      t.datetime :execution_date
      t.belongs_to :order
    end
  end
end
