module Spree
  module Stock
    Prioritizer.class_eval do
      private
      def sort_packages
        Rails.logger.info("sort_packages track: #{caller_locations(0..2)}")
        # order packages by preferred stock_locations
        # de={"ca" => 1, "all" => 0, "us" => 10000}  in string   "{\"gb\":1, \"all\":0, \"us\":10000}"
        # nwb={"ca" => 10000}             in string "{\"gb\":10000}"
        # p=[de,nwb]
        # p.sort!{|t,y| y[o["country"]]<=>t[o["country"]]}  # t y sequence reversed here  p
        return packages unless inventory_units.length>0
        address= inventory_units.first.order.ship_address || inventory_units.first.order.billing_address

        packages.sort!{|f,s| (JSON.parse(s.stock_location.priorities)[address.country.iso.downcase] || JSON.parse(s.stock_location.priorities)["all"] || 0).to_i <=> (JSON.parse(f.stock_location.priorities)[address.country.iso.downcase]  || JSON.parse(f.stock_location.priorities)["all"] || 0).to_i}

        Rails.logger.info("packages after sort: #{packages.length} at locations of #{packages.map(&:stock_location).inspect}")
        packages
      end

      def adjust_packages
        return unless inventory_units.length>0
        inventory_units.each do |inventory_unit|

          adjuster = @adjuster_class.new(inventory_unit, :on_hand)

          visit_packages(adjuster)
          # we do not adjust it by status, so they all will be shipped by one stock_location/warehouse
          #adjuster.status = :backordered
          #visit_packages(adjuster)
        end
      end

      def visit_packages(adjuster)
        packages.each do |package|
          item = package.find_item adjuster.inventory_unit
          adjuster.adjust(package) if item
        end
      end

    end
  end
end
