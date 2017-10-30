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
        return packages unless packages.first.contents.length>0
        address= packages.first.contents.first.inventory_unit.order.ship_address || packages.first.contents.first.inventory_unit.order.billing_address
        #if !!address
        if !!address
          country=address.country
        else
          country= Spree::Country.find(Spree::Config[:default_country_id]) rescue Spree::Country.first
        end
        packages.sort!{|f,s| (JSON.parse(s.stock_location.priorities)[country.iso.downcase] || JSON.parse(s.stock_location.priorities)["all"] || 0).to_i <=> (JSON.parse(f.stock_location.priorities)[country.iso.downcase]  || JSON.parse(f.stock_location.priorities)["all"] || 0).to_i}
        #end
        Rails.logger.debug("packages after sort: #{packages.length} at locations of #{packages.map(&:stock_location).inspect}")
        packages
      end

    end
  end
end
