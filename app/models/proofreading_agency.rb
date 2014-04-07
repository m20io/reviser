class ProofreadingAgency
	attr_reader :backlog
	attr_writer :order_factory

	def initialize
		@backlog = []
	end

	def name
		"Reviser Online"
	end

	def claim
		"Lektorat für zeitnahe Korrektur kuzer Texte."
	end

	def new_order(*args)
		order_factory.call(*args).tap do |order|
			order.proofreading_agency = self
		end
	end

  def backlog_count
		backlog.count
	end

	private
	def order_factory
		@order_factory ||= Order.public_method(:new)
	end
end