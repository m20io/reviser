class Order < ActiveRecord::Base
  attr_accessor :proofreading_agency

  has_one :purchase
end 