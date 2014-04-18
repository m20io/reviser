class AddPaymentInfoToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :payment_id, :string
    add_column :purchases, :payer_id, :string
  end
end
