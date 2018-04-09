Spree::Stock::Adjuster.class_eval do
   def initialize(inventory_unit)
        #self.required_quantity = inventory_unit.required_quantity
        self.required_quantity = inventory_unit.quantity
        self.backorder_package = nil
        self.backorder_item = nil
        self.received_quantity = 0
      end
end
