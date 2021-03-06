#!/usr/bin/env ruby
# View::Preformatted -- xmlconv2 -- 09.06.2004 -- hwyss@ywesee.com

require 'htmlgrid/value'

module XmlConv
	module View
		BREAK_WIDTH = 65
		class Preformatted < HtmlGrid::Value
			def init
				super
				if(@value)	
					raw = @value.gsub(/>\s+</, "><").gsub(/\r\n?/, "\n")
						pretty = CGI.pretty(raw)
					wrap = ''
					pretty.each_line { |line|
						if(line.length < BREAK_WIDTH)
							wrap << line
						else
							parts = line.split('" "')
							wrapline = parts.shift
							while(part = parts.shift)
								if((wrapline.length + part.length) >= BREAK_WIDTH)
									wrap << wrapline
									wrap << "\"\n"
									wrapline = "     \"" << part
								else
									wrapline << '" "' << part
								end
							end
							wrap << wrapline
						end
					}
					@value = CGI.escapeHTML(wrap)
				end
			end
		end
	end
end
