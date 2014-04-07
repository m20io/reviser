class ProofreadingAgency
	attr_reader :orders
	attr_writer :order_factory

	def initialize
		@orders = []
	end

	def name
		"Reviser Online"
	end

	def claim
		"Lektorat für zeitnahe Korrektur kuzer Texte."
	end

	def new_order
		order_factory.call.tap do |order|
			order.proofreading_agency = self
		end
	end

	private
	def order_factory
		@order_factory ||= Order.public_method(:new)
	end
end