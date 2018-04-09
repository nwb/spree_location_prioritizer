module Spree
  class StockLocation < Spree::Base


    def fill_status(variant, quantity)
      if item = stock_item(variant)
        if !variant.track_inventory || item.count_on_hand >= quantity
          on_hand = quantity
          backordered = 0
        else
          on_hand = item.count_on_hand
          on_hand = 0 if on_hand < 0
          backordered = item.backorderable? ? (quantity - on_hand) : 0
        end

        [on_hand, backordered]
      else
        [0, 0]
      end
    end

  end
end
