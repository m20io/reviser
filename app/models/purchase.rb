class Purchase < ActiveRecord::Base
  belongs_to :order
  after_initialize :init
  class IllegalTransition < StandardError; end

  def init
    self.state ||= :incomplete
  end

  def is_incomplete?
    self.state == :incomplete
  end  

  def is_waiting_for_approval?
    self.state == :waiting_for_approval
  end

  def transition_to_waiting_for_approval!
    raise IllegalTransition unless is_incomplete?
    self.state = :waiting_for_approval
  end

  def transition_to_done!
    raise IllegalTransition unless is_waiting_for_approval?
    self.state = :done
  end
end