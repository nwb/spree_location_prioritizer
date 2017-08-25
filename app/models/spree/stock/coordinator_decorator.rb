module Spree
  module Stock
    Coordinator.class_eval do
      # Build packages as per stock location
      #
      # It needs to check whether each stock location holds at least one stock
      # item for the order. In case none is found it wouldn't make any sense
      # to build a package because it would be empty. Plus we avoid errors down
      # the stack because it would assume the stock location has stock items
      # for the given order
      #
      # Returns an array of Package instances
      # we drop the package who does not cover all inventories
      def build_packages(packages = Array.new)
        StockLocation.active.each do |stock_location|
          #next unless stock_location.stock_items.where(:variant_id => inventory_units.map(&:variant_id).uniq).exists?
          # skip the warehouse we can not fulfill the order as one package.
          # this need we have one primary warehouse can ship them all.
          if inventory_units.length>0
          address= inventory_units.first.order.ship_address || inventory_units.first.order.billing_address
          if !!address
            country=address.country
          else
            country= Spree::Country.find(Spree::Config[:default_country_id]) rescue Spree::Country.first
          end
          next if !(JSON.parse(stock_location.priorities)[country.iso.downcase] || JSON.parse(stock_location.priorities)["all"])
          #end
          next unless stock_location.stock_items.where(:variant_id => inventory_units.map(&:variant_id).uniq).select{|si| si.available?}.length == inventory_units.map(&:variant_id).uniq.length
          packer = build_packer(stock_location, inventory_units)
          packages += packer.packages
          end
        end
        packages
      end
    end
  end
end
