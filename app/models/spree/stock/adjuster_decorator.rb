Spree::Stock::Adjuster.class_eval do
   def initialize(inventory_unit)
        self.required_quantity = inventory_unit.line_item.quantity_by_variant[inventory_unit.variant]
        self.backorder_package = nil
        self.backorder_item = nil
        self.received_quantity = 0
      end
end
