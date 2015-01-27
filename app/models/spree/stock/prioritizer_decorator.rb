module Spree
  module Stock
    Prioritizer.class_eval do
      private
      def sort_packages
        # order packages by preferred stock_locations
        # de={"ca" => 1, "all" => 0, "us" => 10000}  in string   "{\"gb\":1, \"all\":0, \"us\":10000}"
        # nwb={"ca" => 10000}             in string "{\"gb\":10000}"
        # p=[de,nwb]
        # p.sort!{|t,y| y[o["country"]]<=>t[o["country"]]}  # t y sequence reversed here  p
        packages.sort!{|f,s| (JSON.parse(s.stock_location.priorities)[order.ship_address.country.iso.downcase] || JSON.parse(s.stock_location.priorities)["all"] || 0) <=> (JSON.parse(f.stock_location.priorities)[order.ship_address.country.iso.downcase]  || JSON.parse(f.stock_location.priorities)["all"] || 0)}
      end
    end
  end
end
