#!/usr/bin/env ruby
# I2::Position -- xmlconv2 -- 02.06.2004 -- hwyss@ywesee.com

require 'i2/date'

module XmlConv
	module I2
		class Position
			attr_accessor :number, :article_ean, :qty
			attr_reader :delivery_date
			def delivery_date=(date)
				date.code = :delivery
				@delivery_date = date
			end
			def to_s
				output = <<-EOS
500:#{@number}
501:#{@article_ean}
520:#{@qty}
				EOS
				if(@delivery_date.is_a?(I2::Date))
					output << @delivery_date.to_s
				end
				output
			end
		end
	end
end