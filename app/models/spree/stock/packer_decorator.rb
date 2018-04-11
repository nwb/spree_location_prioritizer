Spree::Stock::Packer.class_eval do

  def default_package
    package = Spree::Stock::Package.new(stock_location)

    # Group by variant_id as grouping by variant fires cached query.
    inventory_units.index_by(&:variant_id).each do |variant_id, inventory_unit|
      variant = Spree::Variant.find(variant_id)
      unit = inventory_unit.dup # Can be used by others, do not use directly
      unit[:quantity] = inventory_units.group_by {|i| i[:variant_id]}[variant_id].sum {|h| h[:quantity]}
      if variant.should_track_inventory?
        next unless stock_location.stocks? variant
        on_hand, backordered = stock_location.fill_status(variant, unit.quantity)
        if backordered.positive?
          package.add(unit, :backordered)
        else
          package.add unit
        end
        #package.add(Spree::InventoryUnit.split(unit, on_hand), :on_hand) if on_hand.positive?
      else
        package.add unit
      end
    end

    package
  end
end
