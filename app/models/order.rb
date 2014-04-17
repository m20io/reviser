class Order < ActiveRecord::Base
  attr_accessor :proofreading_agency,:purchase

  def is_incomplete?
    false
  end
end 