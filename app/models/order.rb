class Order < ActiveRecord::Base
  attr_accessor :proofreading_agency

  has_one :purchase

  def is_paid?
    purchase.is_done?
  end
end 