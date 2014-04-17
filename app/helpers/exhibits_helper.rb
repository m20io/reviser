module ExhibitsHelper
  def exhibit(model, context)
    case model.class.name
    when 'Order'
      if model.is_incomplete?
        model
      else
        UnpaidOrderExhibit.new(model, context)
      end
    else
      model
    end
  end
end